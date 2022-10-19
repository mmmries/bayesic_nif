use rustler::{Atom, Env, Term};
use rustler::resource::ResourceArc;
use std::sync::Mutex;
use bayesic::Bayesic;

mod atoms {
    rustler::atoms! {
        bad_reference,
        error,
        lock_fail,
        ok,
    }
}

pub struct BayesicResource(Mutex<Bayesic>);

fn load(env: Env, _info: Term) -> bool {
  rustler::resource!(BayesicResource, env);
  true
}

#[rustler::nif]
fn new() -> ResourceArc<BayesicResource> {
  let resource = ResourceArc::new(BayesicResource(Mutex::new(Bayesic::new())));
  resource
}

#[rustler::nif(schedule = "DirtyCpu")]
fn train(resource: ResourceArc<BayesicResource>, class: String, tokens: Vec<String>) -> Result<Atom, Atom> {
  let mut bayesic = match resource.0.try_lock() {
    Err(_) => return Err(atoms::lock_fail()),
    Ok(guard) => guard,
  };

  bayesic.train(class, tokens);

  Ok(atoms::ok())
}

#[rustler::nif(schedule = "DirtyCpu")]
fn classify(resource: ResourceArc<BayesicResource>, tokens: Vec<String>) -> Result<Vec<(String, f64)>, Atom> {

  let bayesic = match resource.0.try_lock() {
    Err(_) => return Err(atoms::lock_fail()),
    Ok(guard) => guard,
  };

  let classification = bayesic.classify(tokens);
  let mut result: Vec<(String, f64)> = vec!();
  for (key, value) in classification {
    result.push((key, value));
  }

  Ok(result)
}

#[rustler::nif(schedule = "DirtyCpu")]
fn prune(resource: ResourceArc<BayesicResource>, uniqueness_threshold: f64) -> Result<Atom, (Atom, Atom)> {
  let mut bayesic = match resource.0.try_lock() {
    Err(_) => return Err((atoms::error(), atoms::lock_fail())),
    Ok(guard) => guard,
  };

  bayesic.prune(uniqueness_threshold);

  Ok(atoms::ok())
}

rustler::init!("Elixir.Bayesic.Nif", [new, train, classify, prune], load = load);