import { newMockEvent } from "matchstick-as"
import { ethereum, BigInt } from "@graphprotocol/graph-ts"
import { newRestaurant } from "../generated/Contract/Contract"

export function createnewRestaurantEvent(
  id: BigInt,
  name: string,
  url_ipfs: string,
  rating: BigInt
): newRestaurant {
  let newRestaurantEvent = changetype<newRestaurant>(newMockEvent())

  newRestaurantEvent.parameters = new Array()

  newRestaurantEvent.parameters.push(
    new ethereum.EventParam("id", ethereum.Value.fromUnsignedBigInt(id))
  )
  newRestaurantEvent.parameters.push(
    new ethereum.EventParam("name", ethereum.Value.fromString(name))
  )
  newRestaurantEvent.parameters.push(
    new ethereum.EventParam("url_ipfs", ethereum.Value.fromString(url_ipfs))
  )
  newRestaurantEvent.parameters.push(
    new ethereum.EventParam("rating", ethereum.Value.fromUnsignedBigInt(rating))
  )

  return newRestaurantEvent
}
