pragma solidity >=0.4.21 <0.6.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";

contract AssetsRegistry is Ownable {
    /**
     * @dev Key is a ticker, values is a destination address
     */
    mapping(bytes32 => bytes32) public assets;

    bytes32[] public tickersList;

    constructor(bytes32[] memory tickers, bytes32[] memory reserveAddresses) public {
        require(tickers.length == reserveAddresses.length, "Tickers length must be equal to addresses length");

        for (uint i = 0; i < tickers.length; i++) {
            require(tickers[i] != 0x0, "Ticker can't be empty");
            require(reserveAddresses[i] != 0x0, "Address can't be empty");

            assets[tickers[i]] = reserveAddresses[i];
            tickersList.push(tickers[i]);
        }
    }

    function getTickers() external view returns(bytes32[] memory) {
        return tickersList;
    }

    function getReserveAddresses() external view returns(bytes32[] memory reserveAddresses) {
        reserveAddresses = new bytes32[](tickersList.length);

        for (uint i = 0; i < tickersList.length; i++) {
            reserveAddresses[i] = assets[tickersList[i]];
        }

        return reserveAddresses;
    }

    function getTickersLength() external view returns(uint256) {
        return tickersList.length;
    }

    function setAsset(bytes32 ticker, bytes32 reserveAddress) external onlyOwner {
        require(ticker != 0x0, "Ticker can't be empty");
        require(reserveAddress != 0x0, "Address can't be empty");

        if (hasTicker(ticker)) {
            removeFromArray(ticker);
        }

        assets[ticker] = reserveAddress;
        tickersList.push(ticker);
    }

    function deleteAsset(bytes32 ticker) external onlyOwner {
        require(ticker != 0x0, "Ticker can't be empty");
        require(hasTicker(ticker), "Ticker doesn't exist");

        assets[ticker] = 0x0;
        removeFromArray(ticker);
    }

    function resetAssets() external onlyOwner {
        for (uint i = 0; i < tickersList.length; i++) {
            assets[tickersList[i]] = 0x0;
        }

        tickersList.length = 0;
    }

    function removeFromArray(bytes32 ticker) internal {
        uint index = getIndexByTicker(ticker);

        tickersList[index] = tickersList[tickersList.length-1];
        delete tickersList[tickersList.length - 1];
        tickersList.length--;
    }

    function hasTicker(bytes32 ticker) internal view returns (bool) {
        return assets[ticker] != 0x0;
    }

    function getIndexByTicker(bytes32 ticker) internal view returns (uint) {
        require(hasTicker(ticker), "Ticker doesn't exist");

        for (uint i = 0; i < tickersList.length; i++) {
            if (tickersList[i] == ticker) {
                return i;
            }
        }

        return 0;
    }
}
