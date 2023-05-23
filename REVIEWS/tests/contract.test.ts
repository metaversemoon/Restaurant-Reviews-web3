import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { BigInt } from "@graphprotocol/graph-ts"
import { newRestaurant } from "../generated/schema"
import { newRestaurant as newRestaurantEvent } from "../generated/Contract/Contract"
import { handlenewRestaurant } from "../src/contract"
import { createnewRestaurantEvent } from "./contract-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/developer/matchstick/#tests-structure-0-5-0

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let id = BigInt.fromI32(234)
    let name = "Example string value"
    let url_ipfs = "Example string value"
    let rating = BigInt.fromI32(234)
    let newnewRestaurantEvent = createnewRestaurantEvent(
      id,
      name,
      url_ipfs,
      rating
    )
    handlenewRestaurant(newnewRestaurantEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/developer/matchstick/#write-a-unit-test

  test("newRestaurant created and stored", () => {
    assert.entityCount("newRestaurant", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "newRestaurant",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "name",
      "Example string value"
    )
    assert.fieldEquals(
      "newRestaurant",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "url_ipfs",
      "Example string value"
    )
    assert.fieldEquals(
      "newRestaurant",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "rating",
      "234"
    )

    // More assert options:
    // https://thegraph.com/docs/en/developer/matchstick/#asserts
  })
})
