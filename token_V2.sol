// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMULIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WAVAX() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityAVAX(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityAVAX(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityAVAXWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactAVAXForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactAVAX(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForAVAX(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapAVAXForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityAVAXSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityAVAXWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactAVAXForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForAVAXSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract GAMETOKEN is Context, ERC20, Ownable {
    using SafeMath for uint256;

    // ##### Constant Value ######

    uint256 private constant TOTAL_SUPPLY = 1000000000 * 10**18;

    uint256 private constant FeeforLP = 2; // 2%
    uint256 private constant FeeforRP = 2; // 2%
    uint256 private constant FeeforBurn = 15; //1.5%
    uint256 private constant FeeforMarketing_Dev = 15;
    uint256 private constant FeeforSalaryTeam = 5; // 0.5%
    uint256 private constant FeeforTreasury = 5; // 0.5%
    uint256 private constant LiquidityPercent = 475; //47.5%
    uint256 private constant RewardPercent = 475;  //47.5%
    uint256 private constant DevPercent = 5; //0.5%
    address private rewardPool;
    address private constant devWallet=0xB5F8A50C8211Ca913E7Ef342e69A5cC34b3d1C65;
    address private constant marketingWallet=0x8664fD9Cafa615900fCc094fDB71569eeEf39fA4;
    address private constant treasuryWallet=0x5265F2876006477e531B2aaD5Ba114523A1Eda53;



    bool private IsSwap = false;
    bool private PublicTradingOpened = false;
    uint256 private TxLimit = 5000000 * 10**18; // 0.5% of total supply
    uint256 private MaxWalletSize = 1000000000 * 10**18; // 100% of total supply
    uint256 private NumOfTokensForDisperse = 5000 * 10**18; // Exchange to Eth Limit - 5 Mil
    address private UniswapV2Pair;
    IUniswapV2Router02 private UniswapV2Router = IUniswapV2Router02(
            0x60aE616a2155Ee3d9A68541Ba4544862310933d4
        );
    bool private SwapEnabled = false;

    //Events

    event tradingOpened(bool _open);
    event setMaxWalletSize(uint256 _maxSize);
    event pairAddress(address _pair);
    event swapEnable(bool _enable);
    event txLimit(uint256 _txLimit);

    ///////////////////////////////////////

    receive() external payable {}

    modifier lockTheSwap() {
        IsSwap = true;
        _;
        IsSwap = false;
    }

    modifier transferable(
        address _sender,
        address _recipient,
        uint256 _amount
    ) {
        if (
            (_sender == UniswapV2Pair &&
                _recipient != address(UniswapV2Router)) ||
            (_recipient == UniswapV2Pair &&
                _sender != address(UniswapV2Router))
        ) require(_amount <= TxLimit, "Amount is too big.");
        _;
        if (
            _recipient != UniswapV2Pair &&
            _recipient != address(UniswapV2Router)
        )
            require(
                ERC20.balanceOf(_recipient) <= MaxWalletSize,
                "The balance is too big"
            );
    }

    constructor() ERC20("Crypto Game", "$CARD") {
        _mint(address(this), TOTAL_SUPPLY);
    }

    // ##### Transfer Feature #####

    function setPublicTradingOpened(bool _enabled) external onlyOwner {
        PublicTradingOpened = _enabled;
        emit tradingOpened(_enabled);
    }

    function isPublicTradingOpened() external view returns (bool) {
        return PublicTradingOpened;
    }

    function setRewardPool(address _rewardPool) external onlyOwner {
        rewardPool = _rewardPool;
    }

    function setTxLimitToken(uint256 _txLimit) external onlyOwner {
        require(_txLimit.mul(10**18) > TOTAL_SUPPLY.div(1000), 'Transaction limit cannot be lower than 0.1% of totalsupply');
        TxLimit = _txLimit.mul(10**18);
        emit txLimit(_txLimit);
    }

    function getTxLimitToken() external view returns (uint256) {
        return TxLimit.div(10**18);
    }

    function setMaxWalletSizeToken(uint256 _maxWalletSize) external onlyOwner {
        MaxWalletSize = _maxWalletSize.mul(10**18);
    }

    function getMaxWalletSizeToken() external view returns (uint256) {
        return MaxWalletSize.div(10**18);
    }

    function transfer(address _recipient, uint256 _amount)
        public
        override
        transferable(_msgSender(), _recipient, _amount)
        returns (bool)
    {
        uint256 realAmount = _feeProcess(_msgSender(), _recipient, _amount);
        _transfer(_msgSender(), _recipient, realAmount);
        return true;
    }

    function transferFrom(
        address _sender,
        address _recipient,
        uint256 _amount
    )
        public
        override
        transferable(_sender, _recipient, _amount)
        returns (bool)
    {
        uint256 realAmount = _feeProcess(_sender, _recipient, _amount);
        _transfer(_sender, _recipient, realAmount);

        _approve(
            _sender,
            _msgSender(),
            allowance(_sender, _msgSender()).sub(
                _amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    // ###### Liquidity Feature ######

    function addLiquidity() external onlyOwner {
        require(!SwapEnabled, "Liquidity pool already created");

        uint256 ethAmount = address(this).balance;
        uint256 amount = balanceOf(address(this)).mul(LiquidityPercent).div(1000);

        require(ethAmount > 0, "Ethereum balance is empty");

        require(amount > 0, "Token balance is empty");

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x60aE616a2155Ee3d9A68541Ba4544862310933d4
        );
        UniswapV2Router = _uniswapV2Router;

        _approve(address(this), address(UniswapV2Router), amount);

        UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WAVAX());

        UniswapV2Router.addLiquidityAVAX{value: ethAmount}(
            address(this),
            amount,
            0,
            0,
            owner(),
            block.timestamp
        );
        SwapEnabled = true;
        IERC20(UniswapV2Pair).approve(
            address(UniswapV2Router),
            type(uint256).max
        );
        emit swapEnable(true);
    }

    function setSwapEnabled (bool _enabled) external onlyOwner {
        SwapEnabled = _enabled;
        emit swapEnable(_enabled);
    }

    function setPairAddress(address _pairAddress) external onlyOwner {
        UniswapV2Pair = _pairAddress;
        emit pairAddress(_pairAddress);
    }

    function setNumOfTokensForDisperse(uint256 _numOfTokensForDisperse)
        external
        onlyOwner
    {
        NumOfTokensForDisperse = _numOfTokensForDisperse.mul(10**18);
    }

    function getNumOfTokensForDisperse() external view returns (uint256) {
        return NumOfTokensForDisperse.div(10**18);
    }

    function _isBuy(address _sender, address _recipient)
        private
        view
        returns (bool)
    {
        return
            _sender == UniswapV2Pair &&
            _recipient != address(UniswapV2Router);
    }

    function _isSale(address _sender, address _recipient)
        private
        view
        returns (bool)
    {
        return
            _recipient == UniswapV2Pair &&
            _sender != address(UniswapV2Router);
    }

    function _swapTokensForAVAX(uint256 _amount) private lockTheSwap {
        address[] memory _path = new address[](2);
        _path[0] = address(this);
        _path[1] = UniswapV2Router.WAVAX();
        _approve(address(this), address(UniswapV2Router), _amount);
        UniswapV2Router.swapExactTokensForAVAXSupportingFeeOnTransferTokens(
            _amount,
            0,
            _path,
            address(this),
            block.timestamp
        );
    }

    function _readyToSwap() private view returns (bool) {
        return !IsSwap && SwapEnabled;
    }

    function _payToll() private {
        uint256 _tokenBalance = balanceOf(address(this));
        if (_readyToSwap()) {
            _swapTokensForAVAX(_tokenBalance);
            payable (UniswapV2Pair).transfer(address(this).balance);
        }
    }

    function _feeProcess(
        address _sender,
        address _recipient,
        uint256 _amount
    ) private returns (uint256) {
        uint256 feeAmount = 0;
        bool isSale = _isSale(_sender, _recipient);
        if (isSale) {
        uint256 feeforLP = _amount.mul(FeeforLP).div(200);
        uint256 feeforRP = _amount.mul(FeeforRP).div(100);
        uint256 feeforMarketing_Dev = _amount.mul(FeeforMarketing_Dev).div(1000);
        uint256 feeforSalaryTeam = _amount.mul(FeeforSalaryTeam).div(1000);
        uint256 feeforTreasury = _amount.mul(FeeforTreasury).div(1000);
        uint256 feeforBurn = _amount.mul(FeeforBurn).div(1000);
        feeAmount = feeforLP.add(feeforRP.add(feeforMarketing_Dev).add(feeforSalaryTeam).add(feeforTreasury).add(feeforBurn));
            _transfer(_sender, UniswapV2Pair, feeforLP);
            _transfer(_sender, rewardPool, feeforRP);
            _transfer(_sender, marketingWallet, feeforMarketing_Dev);
            _transfer(_sender, devWallet, feeforSalaryTeam);
            _transfer(_sender, treasuryWallet, feeforTreasury);
            _transfer(_sender, address(this), feeforLP);
            _burn(_sender, feeforBurn);
            _payToll();
        }

        return _amount.sub(feeAmount);
    }

    // ##### Other Functions ######

    function withdraw(uint256 _amount) external onlyOwner {
        _transfer(address(this), owner(), _amount.mul(10**18));
    }

    function distribute() external onlyOwner {
        uint256 amountForLiquidity = balanceOf(address(this)).mul(LiquidityPercent).div(1000);
        uint256 amountForReward = balanceOf(address(this)).mul(RewardPercent).div(1000);
        uint256 amountForDev = balanceOf(address(this)).mul(DevPercent).div(1000);
        _transfer(address(this), UniswapV2Pair, amountForLiquidity);
        _transfer(address(this), rewardPool, amountForReward);
        _transfer(address(this), devWallet, amountForDev);
    }

    function transferOwnership(address _newOwner) public override onlyOwner {
        Ownable.transferOwnership(_newOwner);
    }
}
