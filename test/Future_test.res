let log = msg => Console.log(msg)
let throw = msg => raise(Failure(msg))

let () = {
  log("Running Future tests...")

  Future.resolved(42)->Future.get(v =>
    if v == 42 { log("PASS: resolved returns correct value = 42") }
    else { throw(`FAIL: expected 42, got ${v->Stdlib.String.make}`) }
  )

  Future.resolved(42)->Future.map(v => v * 2)->Future.get(v =>
    if v == 84 { log("PASS: map transforms value = 84") }
    else { throw(`FAIL: expected 84, got ${v->Stdlib.String.make}`) }
  )

  Future.resolved(10)->Future.flatMap(v => Future.resolved(v * 3))->Future.get(v =>
    if v == 30 { log("PASS: flatMap chains promises = 30") }
    else { throw(`FAIL: expected 30, got ${v->Stdlib.String.make}`) }
  )

  Future.resolved(42)->Future.tap(_ => ())->Future.get(v =>
    if v == 42 { log("PASS: tap returns original promise = 42") }
    else { throw(`FAIL: expected 42, got ${v->Stdlib.String.make}`) }
  )

  Future.resolved(Ok(42))->Future.mapOk(v => v * 2)->Future.get(v =>
    if v == Ok(84) { log("PASS: mapOk transforms Ok value = Ok(84)") }
    else { throw(`FAIL: expected Ok(84), got ${v->Stdlib.String.make}`) }
  )

  Future.resolved(Ok(42))->Future.flatMapOk(v => Future.resolved(Ok(v * 2)))->Future.get(v =>
    if v == Ok(84) { log("PASS: flatMapOk chains on Ok = Ok(84)") }
    else { throw(`FAIL: expected Ok(84), got ${v->Stdlib.String.make}`) }
  )

  Future.resolved(Error("old"))->Future.mapError(_ => 42)->Future.get(v =>
    if v == Error(42) { log("PASS: mapError transforms Error value = Error(42)") }
    else { throw(`FAIL: expected Error(42), got ${v->Stdlib.String.make}`) }
  )

  Future.resolved(Error("old"))->Future.flatMapError(_ => Future.resolved(Error(42)))->Future.get(v =>
    if v == Error(42) { log("PASS: flatMapError chains on Error = Error(42)") }
    else { throw(`FAIL: expected Error(42), got ${v->Stdlib.String.make}`) }
  )

  Future.resolved(Some(42))->Future.mapSome(v => v * 2)->Future.get(v =>
    if v == Some(84) { log("PASS: mapSome transforms Some value = Some(84)") }
    else { throw(`FAIL: expected Some(84), got ${v->Stdlib.String.make}`) }
  )

  Future.resolved(Some(42))->Future.flatMapSome(v => Future.resolved(Some(v * 2)))->Future.get(v =>
    if v == Some(84) { log("PASS: flatMapSome chains on Some = Some(84)") }
    else { throw(`FAIL: expected Some(84), got ${v->Stdlib.String.make}`) }
  )

  Future.all(list{Future.resolved(1), Future.resolved(2), Future.resolved(3)})->Future.get(v =>
    if v == list{1, 2, 3} { log("PASS: all resolves all promises = list{1,2,3}") }
    else { throw(`FAIL: expected list{1,2,3}, got ${v->Stdlib.String.make}`) }
  )

  Future.race(list{Future.resolved(1), Future.resolved(2)})->Future.get(v =>
    if v == 1 { log("PASS: race resolves fastest = 1") }
    else { throw(`FAIL: expected 1, got ${v->Stdlib.String.make}`) }
  )

  Future.allOk(list{Future.resolved(Ok(1)), Future.resolved(Ok(2)), Future.resolved(Ok(3))})->Future.get(v =>
    if v == Ok(list{1, 2, 3}) { log("PASS: allOk resolves all Ok") }
    else { throw(`FAIL: expected Ok(list{1,2,3}), got ${v->Stdlib.String.make}`) }
  )

  Future.allOk(list{Future.resolved(Ok(1)), Future.resolved(Error(2)), Future.resolved(Ok(3))})->Future.get(v =>
    if v == Error(2) { log("PASS: allOk rejects on Error") }
    else { throw(`FAIL: expected Error(2), got ${v->Stdlib.String.make}`) }
  )

  Future.allOk2(Future.resolved(Ok(1)), Future.resolved(Ok(2)))->Future.get(v =>
    if v == Ok((1, 2)) { log("PASS: allOk2 returns tuple of Ok") }
    else { throw(`FAIL: expected Ok((1,2)), got ${v->Stdlib.String.make}`) }
  )

  Future.allOk3(Future.resolved(Ok(1)), Future.resolved(Ok(2)), Future.resolved(Ok(3)))->Future.get(v =>
    if v == Ok((1, 2, 3)) { log("PASS: allOk3 returns tuple of 3 Ok") }
    else { throw(`FAIL: expected Ok((1,2,3)), got ${v->Stdlib.String.make}`) }
  )

  Future.Js.resolved(42)->Future.Js.toResult->Future.get(v =>
    if v == Ok(42) { log("PASS: Js.toResult converts to Result") }
    else { throw(`FAIL: expected Ok(42), got ${v->Stdlib.String.make}`) }
  )

  Future.Js.fromResult(Future.resolved(Ok(42)))->Future.Js.toResult->Future.get(v =>
    if v == Ok(42) { log("PASS: Js.fromResult converts from Result") }
    else { throw(`FAIL: expected Ok(42), got ${v->Stdlib.String.make}`) }
  )

  Future.Js.all(list{Future.Js.resolved(1), Future.Js.resolved(2)})->Future.get(v =>
    if v == list{1, 2} { log("PASS: Js.all resolves list of promises") }
    else { throw(`FAIL: expected list{1,2}, got ${v->Stdlib.String.make}`) }
  )

  Future.Js.race(list{Future.Js.resolved(1), Future.Js.resolved(2)})->Future.get(v =>
    if v == 1 { log("PASS: Js.race resolves fastest promise") }
    else { throw(`FAIL: expected 1, got ${v->Stdlib.String.make}`) }
  )

  Future.Js.relax(Future.resolved(42))->Future.get(v =>
    if v == 42 { log("PASS: Js.relax converts promise to rejectable") }
    else { throw(`FAIL: expected 42, got ${v->Stdlib.String.make}`) }
  )

  log("All tests dispatched!")
}