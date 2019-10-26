pragma solidity >=0.4.21 <0.6.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";

contract AssetsRegistry is Ownable {
    /**
     * @dev Key is a ticker, values is a backup address
     */
    mapping(bytes32 => bytes32) public assets;

    bytes32[] public tickersList;

    constructor(bytes32[] memory tickers, bytes32[] memory backupAddresses) public {
        require(tickers.length == backupAddresses.length, "Tickers length must be equal to addresses length");

        for (uint i = 0; i < tickers.length; i++) {
            require(!isEmpty(tickers[i]), "Ticker can't be empty");
            require(!isEmpty(backupAddresses[i]), "Address can't be empty");

            assets[tickers[i]] = backupAddresses[i];
            tickersList.push(tickers[i]);
        }
    }

    function isEmpty(bytes32 val) internal pure returns(bool) {
        return val[0] == 0;
    }

    function getTickers() external view returns(bytes32[] memory) {
        return tickersList;
    }

    function getBackupAddresses() external view returns(bytes32[] memory backupAddresses) {
        backupAddresses = new bytes32[](tickersList.length);

        for (uint i = 0; i < tickersList.length; i++) {
            backupAddresses[i] = assets[tickersList[i]];
        }

        return backupAddresses;
    }

    function getTickersLength() external view returns(uint256) {
        return tickersList.length;
    }

    function setAsset(bytes32 ticker, bytes32 backupAddress) external onlyOwner {
        require(!isEmpty(ticker), "Ticker can't be empty");
        require(!isEmpty(backupAddress), "Address can't be empty");

        if (hasTicker(ticker)) {
            removeFromArray(ticker);
        }

        assets[ticker] = backupAddress;
        tickersList.push(ticker);
    }

    function deleteAsset(bytes32 ticker) external onlyOwner {
        require(!isEmpty(ticker), "Ticker can't be empty");
        require(hasTicker(ticker), "Ticker doesn't exist");

        delete assets[ticker];
        removeFromArray(ticker);
    }

    function resetAssets() external onlyOwner {
        for (uint i = 0; i < tickersList.length; i++) {
            delete assets[tickersList[i]];
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
        return !isEmpty(assets[ticker]);
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
