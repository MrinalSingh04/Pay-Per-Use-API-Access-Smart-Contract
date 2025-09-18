// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PayPerUseAPI {
    struct API {
        address owner;
        string metadata; // could be endpoint URL / description
        uint256 pricePerCall;
        uint256 pricePerDay;
        bool exists;
    }

    struct Access {
        uint256 remainingCalls;
        uint256 expiry;
    }

    mapping(uint256 => API) public apis;
    mapping(uint256 => mapping(address => Access)) public userAccess;
    uint256 public apiCount;

    event APIRegistered(uint256 apiId, address indexed owner);
    event AccessPurchased(uint256 apiId, address indexed user, uint256 calls, uint256 expiry);
    event FundsWithdrawn(uint256 apiId, address indexed owner, uint256 amount);

    // Developer registers API
    function registerAPI(string memory metadata, uint256 pricePerCall, uint256 pricePerDay) external {
        apiCount++;
        apis[apiCount] = API(msg.sender, metadata, pricePerCall, pricePerDay, true);
        emit APIRegistered(apiCount, msg.sender);
    }

    // Consumer buys calls
    function buyCalls(uint256 apiId, uint256 numCalls) external payable {
        API memory api = apis[apiId];
        require(api.exists, "API not found");
        require(msg.value == api.pricePerCall * numCalls, "Incorrect payment");

        userAccess[apiId][msg.sender].remainingCalls += numCalls;
        emit AccessPurchased(apiId, msg.sender, numCalls, 0);
    }

    // Consumer buys subscription
    function buySubscription(uint256 apiId, uint256 daysAccess) external payable {
        API memory api = apis[apiId];
        require(api.exists, "API not found");
        require(msg.value == api.pricePerDay * daysAccess, "Incorrect payment");

        uint256 newExpiry = block.timestamp + (daysAccess * 1 days);
        if (newExpiry > userAccess[apiId][msg.sender].expiry) {
            userAccess[apiId][msg.sender].expiry = newExpiry;
        }
        emit AccessPurchased(apiId, msg.sender, 0, newExpiry);
    }

    // Developer withdraws funds
    function withdraw(uint256 apiId) external {
        API memory api = apis[apiId];
        require(api.exists, "API not found");
        require(msg.sender == api.owner, "Not API owner");

        uint256 balance = address(this).balance;
        (bool sent,) = payable(api.owner).call{value: balance}("");
        require(sent, "Withdraw failed");

        emit FundsWithdrawn(apiId, api.owner, balance);
    }

    // Check if user has access
    function hasAccess(uint256 apiId, address user) external view returns (bool) {
        Access memory access = userAccess[apiId][user];
        return (access.remainingCalls > 0 || block.timestamp < access.expiry);
    }

    // Use call
    function useCall(uint256 apiId) external {
        Access storage access = userAccess[apiId][msg.sender];
        require(access.remainingCalls > 0, "No call balance");
        access.remainingCalls -= 1;
    }
}
