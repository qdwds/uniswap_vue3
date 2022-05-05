//SPDX-License-Identifier: MIT

pragma solidity =0.6.6;
import "hardhat/console.sol";
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

    function MINIMUM_LIQUIDITY() external pure returns (uint);
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

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
}

interface IUniswapV2Router01 {
    // 获取 工厂合约地址
    function factory() external pure returns (address);
    // 获取WETH合约地址
    function WETH() external pure returns (address);
    // 添加流动性
    function addLiquidity( address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
    // 添加ETH流动性
    function addLiquidityETH( address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    // 移除5流动性
    function removeLiquidity( address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB);
    // 移除ETH流动性
    function removeLiquidityETH( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
    //  移除带签名的流动性
    function removeLiquidityWithPermit( address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amountA, uint amountB);
    
    function removeLiquidityETHWithPermit( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amountToken, uint amountETH);
    
    function swapExactTokensForTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    
    function swapTokensForExactTokens( uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
    
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
    
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(address token,uint liquidity,uint amountTokenMin,uint amountETHMin,address to,uint deadline) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token,uint liquidity,uint amountTokenMin,uint amountETHMin,address to,uint deadline,bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amountETH);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn,uint amountOutMin,address[] calldata path,address to,uint deadline) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin,address[] calldata path,address to,uint deadline) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn,uint amountOutMin,address[] calldata path,address to,uint deadline) external;
}



contract UniswapV2Router02 is IUniswapV2Router02 {
    using SafeMath for uint;
    // 工厂合约地址
    address public immutable override factory;
    // WETH合约地址
    address public immutable override WETH;

    // 判定当前区块时间不能超过最晚交易时间
    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, "UniswapV2Router: EXPIRED");
        _;
    }

    constructor(address _factory, address _WETH) public {
        factory = _factory;
        WETH = _WETH;
    }

    // 限制只能从WETH合约直接接受ETH，也就是在WETH提取为ETH时。
    // 调用者之传ETH，并未调用函数，未提供信息，receive触发
    receive() external payable {
        assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
    }

    /**
    * **** ADD LIQUIDITY ****
    * @dev 添加流动性的私有方法,整个方法是在运算。给出A B 的最优数额
    */
    function _addLiquidity(
        address tokenA,         //  tokenA地址
        address tokenB,         //  tokenB地址
        uint amountADesired,    //  期望数量A
        uint amountBDesired,    //  期望数量B
        uint amountAMin,        //  最小数量A
        uint amountBMin         //  最小数量B
    ) internal virtual returns (
        uint amountA,   //  数量A
        uint amountB    //  数量B
    ) {
        // 如果这个交易对不存在，则创建一个交易对
        if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
            IUniswapV2Factory(factory).createPair(tokenA, tokenB);
        }
        // 获取交易对中两个代币的存储量。
        (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
        // 两个交易对的代币储备量都为0
        if (reserveA == 0 && reserveB == 0) {
            // 使用用户 自定义的注入量
            (amountA, amountB) = (amountADesired, amountBDesired);
        } 
        // 如果当前配对
        else {
            // 计算注入最优注入量
            uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
            //如果B的最优注入 <= B的期望注入量，说明用户B的数量足够
            if (amountBOptimal <= amountBDesired) {
                // 确保B的最优注入量 >= 最小注入量
                require(amountBOptimal >= amountBMin, "UniswapV2Router: INSUFFICIENT_B_AMOUNT");
                // 返回A/B注入量
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                // 计算A的最优注入量
                uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
                // 确保用户Ade 数量足够
                assert(amountAOptimal <= amountADesired);
                // 保证A最优注入量 >= 最小注入量
                require(amountAOptimal >= amountAMin, "UniswapV2Router: INSUFFICIENT_A_AMOUNT");
                // 返回A/B注入量
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }
    }

    // 添加流动性方法
    function addLiquidity(
        address tokenA,         //  tokenA地址
        address tokenB,         //  tokenB地址
        uint amountADesired,    //  期望数量A
        uint amountBDesired,    //  期望数量B
        uint amountAMin,        //  最小数量A
        uint amountBMin,        //  最小数量B
        address to,             //  to地址
        uint deadline           //  最后期限
    ) external virtual override ensure(deadline) returns (
        uint amountA,   //  数量A
        uint amountB,   //  数量B
        uint liquidity  //  流动性数量
    ) {
        // 先计算出最优A/B注入量。
        (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
        // 预测tokenA 和 TokenB的合约地址
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
        // 将tokenA 和 TokenB 转到交易对中
        TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
        TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
        // 调用Pair的 添加流动性方法
        liquidity = IUniswapV2Pair(pair).mint(to);
        console.log("addLiquidity liquidity", liquidity);
    }

    /**
    * @dev 添加ETH流动性方法
    把eth转成weth
    */
    function addLiquidityETH(
        address token,              //  token地址
        uint amountTokenDesired,    //  Token期望数量
        uint amountTokenMin,        //  Token最小数量
        uint amountETHMin,          //  ETH最小数量
        address to,                 //  to地址
        uint deadline               //  最后期限
    ) external virtual override payable ensure(deadline) returns (
        uint amountToken,   //  Token数量
        uint amountETH,     //  ETH数量
        uint liquidity      //  流动性数量
    ) {
        // 计算最优量
        (amountToken, amountETH) = _addLiquidity(
            token,
            WETH,
            amountTokenDesired,
            msg.value,
            amountTokenMin,
            amountETHMin
        );
        // 预测合约地址
        address pair = UniswapV2Library.pairFor(factory, token, WETH);
        // 把指定token的value从form转到to地址（交易对）中
        TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
        // 把ETH注入到WETH池子中
        IWETH(WETH).deposit{value: amountETH}();
        // 转账WETH到到 交易对中，并且根据转账的返回值。判断是否转账成功
        assert(IWETH(WETH).transfer(pair, amountETH));
        // 创建流动性，并转入用户地址
        liquidity = IUniswapV2Pair(pair).mint(to);
        console.log("addLiquidityETH liquidity", liquidity);
        // refund dust eth, if any
        // 如果还有剩余的ETH则返回剩余的ETH
        console.log("addLiquidityETH msg.value > amountETH", msg.value > amountETH);
        if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
    }

    // **** REMOVE LIQUIDITY ****
    /**
     * @dev 移除流动性
     */
    function removeLiquidity(
        address tokenA,    //  tokenA地址
        address tokenB,    //  tokenB地址
        uint liquidity,    //  流动性数量
        uint amountAMin,   //  最小数量A
        uint amountBMin,   //  最小数量B
        address to,        //  to地址 销毁给谁
        uint deadline      //  最后期限
    ) public virtual override ensure(deadline) returns (
        uint amountA,   //  数量A
        uint amountB    //  数量B
    ) {
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
        IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
        (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
        (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
        require(amountA >= amountAMin, "UniswapV2Router: INSUFFICIENT_A_AMOUNT");
        require(amountB >= amountBMin, "UniswapV2Router: INSUFFICIENT_B_AMOUNT");
    }
    /**
     * @dev 移除ETH流动性
     */
    function removeLiquidityETH(
        address token,      //  token地址
        uint liquidity,     //  流动性数量
        uint amountTokenMin,//  token最小数量
        uint amountETHMin,  //  ETH最小数量
        address to,         //  to地址
        uint deadline       //  最后期限
    ) public virtual override ensure(deadline) returns (
        uint amountToken,  // token数量
         uint amountETH    // ETH数量
    ){
        (amountToken, amountETH) = removeLiquidity(
            token,
            WETH,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline
        );
        TransferHelper.safeTransfer(token, to, amountToken);
        IWETH(WETH).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }
    /**
     * @dev 带签名移除流动性
     */
    function removeLiquidityWithPermit(
        address tokenA,    //  tokenA地址
        address tokenB,    //  tokenB地址
        uint liquidity,    //  流动性数量
        uint amountAMin,   //  最小数量A
        uint amountBMin,   //  最小数量B
        address to,        //  to地址
        uint deadline,     //  最后期限
        bool approveMax,   //  全部批准
        uint8 v,           //  v
        bytes32 r,         //  r
        bytes32 s          //  s
    ) external virtual override returns (
        uint amountA,   //  数量A
        uint amountB    //  数量B
    ) {
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
        uint value = approveMax ? uint(-1) : liquidity;
        IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
        (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
    }
    /**
     * @dev 带签名移除ETH流动性
     */
    function removeLiquidityETHWithPermit(
        address token,        //  token地址
        uint liquidity,       //  流动性数量
        uint amountTokenMin,  //  token最小数量
        uint amountETHMin,    //  ETH最小数量
        address to,           //  to地址
        uint deadline,        //  最后期限
        bool approveMax,      //  全部批准
        uint8 v,              //  v
        bytes32 r,            //  r
        bytes32 s             //  s
    ) external virtual override returns (
        uint amountToken,   //  token数量
        uint amountETH      //  ETH数量
    ) {
        address pair = UniswapV2Library.pairFor(factory, token, WETH);
        uint value = approveMax ? uint(-1) : liquidity;
        IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
        (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
    }

    // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,      //  
        uint liquidity,     //  
        uint amountTokenMin,//  
        uint amountETHMin,  //  
        address to,         //  
        uint deadline       //  
    ) public virtual override ensure(deadline) returns (
        uint amountETH      //  
    ) {
        (, amountETH) = removeLiquidity(
            token,
            WETH,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline
        );
        TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
        IWETH(WETH).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,      //  
        uint liquidity,     //  
        uint amountTokenMin,//  
        uint amountETHMin,  //  
        address to,         //  
        uint deadline,      //  
        bool approveMax,    //  
        uint8 v,            //  
        bytes32 r,          //  
         bytes32 s          //  
    ) external virtual override returns (
        uint amountETH      // 
    ) {
        address pair = UniswapV2Library.pairFor(factory, token, WETH);
        uint value = approveMax ? uint(-1) : liquidity;
        IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
        amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
            token, liquidity, amountTokenMin, amountETHMin, to, deadline
        );
    }

    // **** SWAP ****
    // requires the initial amount to have already been sent to the first pair
    /**
     * @dev 私有交换
     */
    function _swap(
        uint[] memory amounts,  //  要求初始金额已经发送到第一对
        address[] memory path,  //  数额数组
        address _to             //  to地址
    ) internal virtual {
        for (uint i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0,) = UniswapV2Library.sortTokens(input, output);
            uint amountOut = amounts[i + 1];
            (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
            address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
            IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
                amount0Out, amount1Out, to, new bytes(0)
            );
        }
    }

    /**
     * @dev 根据精确的token交换尽量多的token
     给输入求输出
     */
    function swapExactTokensForTokens(
        uint amountIn,          //  精确输入数额
        uint amountOutMin,      //  最小输出数额
        address[] calldata path,//  路径数组
        address to,             //  to地址
        uint deadline           //  最后期限
    ) external virtual override ensure(deadline) returns (
        uint[] memory amounts   //数额数组
    ) {
        amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
        require(amounts[amounts.length - 1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
        );
        _swap(amounts, path, to);
    }

    /**
     * @dev 使用尽量少的token交换精确的token
     给输出 求输入
     */
    function swapTokensForExactTokens(
        uint amountOut,         //  精确输出数额
        uint amountInMax        //  最大输入数额
        address[] calldata path,//  路径数组
        address to,             //  to地址
        uint deadline           //  最后期限
    ) external virtual override ensure(deadline) returns (
        uint[] memory amounts   //  数额数组
    ) {
        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
        require(amounts[0] <= amountInMax, "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
        );
        _swap(amounts, path, to);
    }
    /**
     * @dev 根据精确的ETH交换尽量多的token
     输入ETH求输出
     */
    function swapExactETHForTokens(
        uint amountOutMin,      //  最小输出数额
        address[] calldata path,//  路径数组
        address to,             //  to地址
        uint deadline           //  最后期限
    ) external virtual override payable ensure(deadline) returns (
        uint[] memory amounts      //  数额数组
    ){
        require(path[0] == WETH, "UniswapV2Router: INVALID_PATH");
        amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
        require(amounts[amounts.length - 1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
        IWETH(WETH).deposit{value: amounts[0]}();
        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
        _swap(amounts, path, to);
    }

    /**
     * @dev 使用尽量少的token交换精确的ETH
     给输出ETH 求 输入
     */
    function swapTokensForExactETH(
        uint amountOut,         //  精确输出数额
        uint amountInMax,       //  最大输入数额
        address[] calldata path,//  路径数组
        address to,             //  to地址
        uint deadline           //  最后期限
    ) external virtual override ensure(deadline) returns (
        uint[] memory amounts   //  数额数组
    ){
        require(path[path.length - 1] == WETH, "UniswapV2Router: INVALID_PATH");
        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
        require(amounts[0] <= amountInMax, "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
        );
        _swap(amounts, path, address(this));
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }

    /**
     * @dev 根据精确的token交换尽量多的ETH
    //  给输入token 输出 ETH
     */
    function swapExactTokensForETH(
        uint amountIn,          //  精确输入数额
        uint amountOutMin,      //  最小输出数额
        address[] calldata path,//  路径数组
        address to,             //  to地址
        uint deadline           //  最后期限
    ) external virtual override ensure(deadline) returns (
        uint[] memory amounts   //  数额数组
    ){
        require(path[path.length - 1] == WETH, "UniswapV2Router: INVALID_PATH");
        amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
        require(amounts[amounts.length - 1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
        );
        _swap(amounts, path, address(this));
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }

    /**
     * @dev 使用尽量少的ETH交换精确的token
     给 输出精确toekn 求输入 ETH
     */
    function swapETHForExactTokens(
        uint amountOut,         //  精确输出数额
        address[] calldata path,//  路径数组
        address to,             //  to地址
        uint deadline           //  最后期限
    ) external virtual override payable ensure(deadline) returns (
        uint[] memory amounts  //  数额数组
    ){
        require(path[0] == WETH, "UniswapV2Router: INVALID_PATH");
        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
        require(amounts[0] <= msg.value, "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
        IWETH(WETH).deposit{value: amounts[0]}();
        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
        _swap(amounts, path, to);
        // refund dust eth, if any
        if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
    }

    // **** SWAP (supporting fee-on-transfer tokens) ****
    // requires the initial amount to have already been sent to the first pair
    function _swapSupportingFeeOnTransferTokens(
        address[] memory path,  // 
        address _to             // 
    ) internal virtual {
        for (uint i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0,) = UniswapV2Library.sortTokens(input, output);
            IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
            uint amountInput;
            uint amountOutput;
            { // scope to avoid stack too deep errors
            (uint reserve0, uint reserve1,) = pair.getReserves();
            (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
            amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
            amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
            }
            (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
            address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
            pair.swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,          // 
        uint amountOutMin,      // 
        address[] calldata path,// 
        address to,             // 
        uint deadline           // 
    ) external virtual override ensure(deadline) {
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
        );
        uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
        _swapSupportingFeeOnTransferTokens(path, to);
        require(
            IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
            "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT"
        );
    }
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,      // 
        address[] calldata path,// 
        address to,             // 
        uint deadline           // 
    ) external virtual override payable ensure(deadline)
    {
        require(path[0] == WETH, "UniswapV2Router: INVALID_PATH");
        uint amountIn = msg.value;
        IWETH(WETH).deposit{value: amountIn}();
        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
        uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
        _swapSupportingFeeOnTransferTokens(path, to);
        require(
            IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
            "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT"
        );
    }
    // 将精确代币兑换为ETH转账代币支持费
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,          // 
        uint amountOutMin,      // 
        address[] calldata path,// 
        address to,             // 
        uint deadline           // 
    ) external virtual override ensure(deadline)
    {
        require(path[path.length - 1] == WETH, "UniswapV2Router: INVALID_PATH");
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
        );
        _swapSupportingFeeOnTransferTokens(path, address(this));
        uint amountOut = IERC20(WETH).balanceOf(address(this));
        require(amountOut >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
        IWETH(WETH).withdraw(amountOut);
        TransferHelper.safeTransferETH(to, amountOut);
    }

    // **** LIBRARY FUNCTIONS ****
    // 求对价
    function quote(
        uint amountA,   // 
        uint reserveA,  // 
        uint reserveB   // 
    ) public pure virtual override returns (
        uint amountB   // 
    ) {
        return UniswapV2Library.quote(amountA, reserveA, reserveB);
    }

    // 从写lib 方法并且对外暴露
    // **** LIBRARY FUNCTIONS ****
    // 求输出
    function getAmountOut(
        uint amountIn,    //
        uint reserveIn,   //
        uint reserveOut   //
    ) public pure virtual override returns (
        uint amountOut    //
    ){
        return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
    }

    // 求输入
    function getAmountIn(
        uint amountOut,   //
        uint reserveIn,   //
        uint reserveOut   //
    ) public pure virtual override returns (
        uint amountIn   //
    ){
        return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
    }

    function getAmountsOut(
        uint amountIn,          //
        address[] memory path   //
    ) public view virtual override returns (
        uint[] memory amounts   //
    ){
        return UniswapV2Library.getAmountsOut(factory, amountIn, path);
    }

    function getAmountsIn(
        uint amountOut,         //
        address[] memory path   //
    ) public view virtual override returns (
        uint[] memory amounts   //
    ){
        return UniswapV2Library.getAmountsIn(factory, amountOut, path);
    }
}

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }
}

library UniswapV2Library {
    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    // token排序 （ 小 , 大)
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), "UniswapV2Library: ZERO_ADDRESS");
    }

    // calculates the CREATE2 address for a pair without making any external calls
    // 使用create2 预测合约地址
    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex"ff",
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                // uniswapV2Factory 的字节码 ( INIT_CODE_PAIR_HASH )
                hex"6514c4a4acb567240d98ed68dd26ed635559313c8c728536d174408bb2820ed8" // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    // 获取交易对的存储量
    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        // token 排序
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
        // 排序返回
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    // 计算最优注入量
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");
        require(reserveA > 0 && reserveB > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        // amountA * reserveB / reserveA
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
}

// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes("approve(address,uint256)")));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferHelper: APPROVE_FAILED");
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes("transfer(address,uint256)")));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferHelper: TRANSFER_FAILED");
    }
    
    //  把指定token的value从form转到to地址(可以是交易对)中。
    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferHelper: TRANSFER_FROM_FAILED");
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, "TransferHelper: ETH_TRANSFER_FAILED");
    }
}