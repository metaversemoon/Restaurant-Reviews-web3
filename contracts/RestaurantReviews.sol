//SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0 < 0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";
// Use openzeppelin to inherit battle-tested implementations (ERC20, ERC721, etc)
// import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * A smart contract that allows changing a state variable of the contract and tracking the changes
 * It also allows the owner to withdraw the Ether in the contract
 * @author BuidlGuidl
 */
contract RestaurantReviews {
    struct Restaurant {
        uint256 id;
        string name;
        string url_ipfs;
        uint256[] reviewIds;
        uint256 rating;
        string tableLand;
    }

    struct Review {
        uint256 id;
        uint256 restaurantId;
        string url_ipfs;
    }

    mapping(uint256 => Restaurant) public restaurants;
    mapping(uint256 => Review) public reviews;

    uint256 public restaurantCount;
    uint256 public reviewCount;

    event newRestaurant(
        uint256 id,
        string name,
        string url_ipfs,
        uint256 rating,
        string tableLand
    );

    function addRestaurant(string memory _name, string memory _url_ipfs, uint256 _rating, string memory _tableLand) public {
        restaurantCount++;
        restaurants[restaurantCount] = Restaurant({
            id: restaurantCount,
            name: _name,
            url_ipfs: _url_ipfs,
            reviewIds: new uint256[](0),
            rating: _rating,
            tableLand: _tableLand
        });
        emit newRestaurant(
            restaurantCount,
            _name,
            _url_ipfs,
            _rating,
            _tableLand
        );
    }

    function addReview(uint256 _restaurantId, string memory _url_ipfs) public {
        require(_restaurantId <= restaurantCount, "Invalid restaurant ID");
        reviewCount++;
        reviews[reviewCount] = Review({
            id: reviewCount,
            restaurantId: _restaurantId,
            url_ipfs: _url_ipfs
        });
        restaurants[_restaurantId].reviewIds.push(reviewCount);
    }

    function getRestaurant(uint256 _restaurantId) public view returns(uint256, string memory, string memory, uint256[] memory, uint256) {
        require(_restaurantId <= restaurantCount, "Invalid restaurant ID");
        Restaurant memory restaurant = restaurants[_restaurantId];
        return (restaurant.id, restaurant.name, restaurant.url_ipfs, restaurant.reviewIds, restaurant.rating);
    }

    function getAllRestaurants() public view returns(Restaurant[] memory) {
        Restaurant[] memory allRestaurants = new Restaurant[](restaurantCount);
        for (uint i = 0; i < restaurantCount; i++) {
            Restaurant storage currentRestaurant = restaurants[i];
            allRestaurants[i] = currentRestaurant;
        }
        return allRestaurants;
    }


    function getReviewsByRestaurant(uint256 _restaurantId) public view returns(uint256[] memory) {
        require(_restaurantId <= restaurantCount, "Invalid restaurant ID");
        return restaurants[_restaurantId].reviewIds;
    }
}
