import { newRestaurant as newRestaurantEvent } from "../generated/Contract/Contract"
import { newRestaurant } from "../generated/schema"

export function handlenewRestaurant(event: newRestaurantEvent): void {
  let entity = new newRestaurant(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.Contract_id = event.params.id
  entity.name = event.params.name
  entity.url_ipfs = event.params.url_ipfs
  entity.rating = event.params.rating

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
