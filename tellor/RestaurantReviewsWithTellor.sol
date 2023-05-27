// SPDX-License-Identifier: GPL-3.0

// TODO: get restaurant hours using Tellor

// 1 User-Buyer gets data
// dataProvider(it has data that u need) => buyData
//  PLAYGROUND => takes ur $$ from ur wallet  & then can use it to pay for data
// RICKANDMORTY => allows to call the buyData function

// 2 User becomes the dataProvider

//  Questions:
//  what api can i use: Yelp?
// I have a few questions, what api can i use?
// Say I am using Yelps API, how this api works with Tellor?
// what will be the process in terms of calling the contract when requesting data?

pragma solidity 0.8 .0;
import "usingtellor/contracts/UsingTellor.sol";

contract RestaurantReviewsWithTellor is UsingTellor {
    //  calling API to get business hours ? =>
    // This Contract now has access to all functions in UsingTellor
    // REF: https://github.com/tellor-io/dataSpecs/blob/main/types/NumericApiResponse.md
    string public queryType = "NumericApiResponse"; // name of query type
    string public url = "https://rickandmortyapi.com/api/episode"; // url of API
    string public parseArgs = "info, count"; // arguments we need to parse the JSON response

    uint256 public savedEpisodeCount; // last episode count retrieved from Tellor oracle

    constructor(address payable _tellorAddress) UsingTellor(_tellorAddress) {}

    function readValue() public view returns(uint256, uint256) {
        //build our queryData
        bytes memory _queryData = abi.encode(queryType, abi.encode(url, parseArgs));
        //hash it (build our queryId)
        bytes32 _queryId = keccak256(_queryData);
        //get our data. Using a delay of 5 seconds is NOT recommended for production. More on this in the docs.
        (bytes memory _value, uint256 _timestamp) = getDataBefore(_queryId, block.timestamp - 5 seconds);
        //decode our data returned in decimal
        return (abi.decode(_value, (uint256)), _timestamp);
    }

    function readAndSaveValue() public {
        (uint256 _value, uint256 _timestamp) = readValue();
        if (_timestamp > 0) {
            savedEpisodeCount = _value;
        }
    }


    struct Restaurant {
        uint256 id;
        string name;
        string url_ipfs;
        uint256[] reviewIds;
        uint256 rating;
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
        uint256 rating
    );


    function addRestaurant(string memory _name, string memory _url_ipfs, uint256 _rating) public {
        restaurantCount++;
        restaurants[restaurantCount] = Restaurant({
            id: restaurantCount,
            name: _name,
            url_ipfs: _url_ipfs,
            reviewIds: new uint256[](0),
            rating: _rating
        });
        emit newRestaurant(
            restaurantCount,
            _name,
            _url_ipfs,
            _rating
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

    function getAllRestaurants() public view returns(uint256[] memory) {
        uint256[] memory ids = new uint256[](restaurantCount);
        for (uint256 i = 1; i <= restaurantCount; i++) {
            ids[i - 1] = i;
        }
        return ids;
    }

    function getReviewsByRestaurant(uint256 _restaurantId) public view returns(uint256[] memory) {
        require(_restaurantId <= restaurantCount, "Invalid restaurant ID");
        return restaurants[_restaurantId].reviewIds;
    }
}
