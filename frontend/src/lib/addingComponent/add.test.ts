import { assert, test } from "vitest";
import { add } from "./add";

test("Test adding", ()=>{
  assert.equal(add(2,2), 4)
})