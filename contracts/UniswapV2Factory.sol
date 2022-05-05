//SPDX-License-Identifier: MIT
pragma solidity =0.5.16;
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

interface IUniswapV2ERC20 {
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

interface IUniswapV2Callee {
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}

contract UniswapV2ERC20 is IUniswapV2ERC20 {
    using SafeMath for uint;

    string public constant name = "Uniswap V2";
    string public constant symbol = "UNI-V2";
    uint8 public constant decimals = 18;
    uint  public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    bytes32 public DOMAIN_SEPARATOR;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public nonces;

    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    constructor() public {
        uint chainId;
        assembly {
            chainId := chainid
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes(name)),
                keccak256(bytes("1")),
                chainId,
                address(this)
            )
        );
    }

    function _mint(address to, uint value) internal {
        totalSupply = totalSupply.add(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(address(0), to, value);
    }

    function _burn(address from, uint value) internal {
        balanceOf[from] = balanceOf[from].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Transfer(from, address(0), value);
    }

    function _approve(address owner, address spender, uint value) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(address from, address to, uint value) private {
        balanceOf[from] = balanceOf[from].sub(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint value) external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) external returns (bool) {
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _transfer(from, to, value);
        return true;
    }

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        require(deadline >= block.timestamp, "UniswapV2: EXPIRED");
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, "UniswapV2: INVALID_SIGNATURE");
        _approve(owner, spender, value);
    }
}

contract UniswapV2Pair is IUniswapV2Pair, UniswapV2ERC20 {
    using SafeMath  for uint;
    // 为什么用uint224，因为solidity中没有非整数类型。但是token的数量肯定回有小数。shiyong UQ112*112去模拟浮点类型。
    using UQ112x112 for uint224;

    // 最小流动性
    uint public constant MINIMUM_LIQUIDITY = 10**3;
    // transfor bytecode 使用使用call调用token的transfer方法
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));

    // 工厂地址。因为pair合约是通过工厂合约进行部署，所以需要有一个存放工厂合约的地址
    address public factory;
    address public token0;
    address public token1;
    
    // 但前pair合约所持有的token数量。
    // reserve0 + reserve1 + blockTimestampLast == uint的位数
    uint112 private reserve0;           // uses single storage slot, accessible via getReserves
    uint112 private reserve1;           // uses single storage slot, accessible via getReserves
    // 用于判断是不是区块的第一笔交易。
    uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves

    // 介个最后累计
    // 用于unistap v2 所提供的价格预言机上。该数值会在每个区块的第一笔交易进行更新。
    uint public price0CumulativeLast;
    uint public price1CumulativeLast;

    // reserve0 * reserve1, 最近一次流动性事件发生后立即生效
    // 这个变量在没有开启收费模式的时候，等于0.只有开启平台收费的时候，这个值才等于k值，因为一般平台开启收费开，k就不会等于两个存储量相乘的结果。
    uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event

    // 锁定变量，防止重、重入攻击。
    uint private unlocked = 1;
    // 一个锁，只有unlocked == 1的时候才能调用。
    // 第一个调用者进入后，会将unlocked = 0，第二个调用者无法进入
    // 执行完后将 unlocked = 1；重新将锁打开
    modifier lock() {
        require(unlocked == 1, "UniswapV2: LOCKED");
        unlocked = 0;
        _;
        unlocked = 1;
    }

    // 获取token0和token1的储备量。和上一个区块的时间戳
    function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
        console.log("_reserve0", _reserve0 );
        console.log("_reserve1", _reserve1);
        console.log("_blockTimestampLast", _blockTimestampLast);
        console.log("getReserves",_reserve0 + _reserve1 + _blockTimestampLast);
    }

    /*
    * @dev 私有安全发送
    * @param token token地址
    * @param to to地址
    * @param value 数额
    */
    function _safeTransfer(address token, address to, uint value) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "UniswapV2: TRANSFER_FAILED");
    }

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
    // 同步事件
    event Sync(uint112 reserve0, uint112 reserve1);
    
    constructor() public {
        factory = msg.sender;
    }

    //  在部署时由工厂调用一次
    //  在UNiswapV2Factory.sol中的 createPair 方法中调用
    function initialize(address _token0, address _token1) external {
        // 确认工厂合约地址
        require(msg.sender == factory, "UniswapV2: FORBIDDEN"); // sufficient check
        token0 = _token0;
        token1 = _token1;
    }

    // 更新计算累计价格
    /*
    * @dev 更新储备量，并在每一个区块的第一次调用时，更新价格累加器
    * @param balance0 余额0
    * @param balance1 余额1
    * @param _reserve0 储备量0
    * @param _reserve1 储备量1
    * update reserves and, on the first call per block, price accumulators
    */
    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        // 确认余额0和余额1大于最大的uint112
        require(balance0 <= uint112(-1) && balance1 <= uint112(-1), "UniswapV2: OVERFLOW");
        // 区块链时间戳，将时间戳转为uint32
        uint32 blockTimestamp = uint32(block.timestamp % 2**32);
        // 计算时间流逝
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
        
        // 计算时间加权的累计价格，256中，前112位存储整数，后112存储小数，多的32位存储溢出值
        // 如果时间流逝 > 0，并且储备量0和储备量1 !== 0，也就是第一个调用
        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
            // * never overflows, and + overflow is desired
            // 价格0最后累计 += 储备量1 * 2 ** 112 / 储备量0 * 时间流逝
            price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
            price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
        }
        // 更新两个代币数量
        // 余额0和余额1 放入 储备量0和储备量1 中
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        // 更新最后时间戳
        blockTimestampLast = blockTimestamp;
        emit Sync(reserve0, reserve1);
    }

    // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
    // 计算手续费
    // 如果收费，则铸币流动性相当于 sqrt(k) 增长的 1/6
    // 每笔交易有千分之三的手续费，k值也会随着缓慢增加，所有连续两个字段之间k值的差值就是这段时间的手续费。
    /*
    * @dev 如果收费，铸造流动性相当于1/6的增长sqrt(k)
    * @param _reserve0 储备量0
    * @param _reserve1 储备量1
    * @return feeOn
    * 这一部分可参考白皮书协议费用那部分·
    * if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
    */
    function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
        // 查询工厂合约的feeTo变量值
        address feeTo = IUniswapV2Factory(factory).feeTo();
        console.log("_mintFee 滑点", feeTo);
        // 如果feeTo != 0地址吗，feeOn等于 true 否则 false
        // feeOn = teeTo != address(0) ? treu :false;
        feeOn = feeTo != address(0);
        console.log("_mintFee feeOn",feeOn);
        // 定义k值
        uint _kLast = kLast; // gas savings
        // 如果feeOn等于true
        if (feeOn) {
            // k 不等于 0
            if (_kLast != 0) {
                // 计算（_reserve0*_reserve1）的平方根
                uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
                // 计算k值的平方根
                uint rootKLast = Math.sqrt(_kLast);
                if (rootK > rootKLast) {
                    // 分子 = erc20总量 * (rootK - rootKlast)
                    uint numerator = totalSupply.mul(rootK.sub(rootKLast));
                    // 分母 = rootK * 5 + rootKLast
                    uint denominator = rootK.mul(5).add(rootKLast);
                    // 流动性 = 分子 / 分母
                    uint liquidity = numerator / denominator;
                    // 流动性 > 0 将流动性铸造给feeTo地址
                    if (liquidity > 0) _mint(feeTo, liquidity);
                }
            }
        } else if (_kLast != 0) {
            kLast = 0;
        }
    }

    //  添加流动性
    // this low-level function should be called from a contract which performs important safety checks
    function mint(address to) external lock returns (uint liquidity) {
        // 获取两个token的最新数据
        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
        // 两个token在工厂合约中的余额
        uint balance0 = IERC20(token0).balanceOf(address(this));
        uint balance1 = IERC20(token1).balanceOf(address(this));
        // 计算当前余额和 上次缓存中的 差值
        // amount0 = 余额0 - 储备0
        uint amount0 = balance0.sub(_reserve0);
        // amount1 = 余额1 - 储备1
        uint amount1 = balance1.sub(_reserve1);
        // 返回铸造费开关
        bool feeOn = _mintFee(_reserve0, _reserve1);
        uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
        if (_totalSupply == 0) {
            // 第一次铸币（第一次添加流动信），值为 根号k - MINIMUM_LIQUIDITY（最小流动性）
            // 流动性 = (数量0 * 数量1)的平方根 - 最小流动性1000
            liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
            console.log("main liquidity", liquidity);
            // 把 MINIMUM_LIQUIDITY 赋值给地址0，永久锁住
            // 在总量为0的初始状态，永久锁定最低流动性
           _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
        } else {
            // 计算增量的token占总池子的比例，作为新币的数量。
            // 流动性 = 最小值(amount0 * _totalSupply - _reserve0 和 (amount1 * _totalSupply) / reserve1)
            liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
        }
        require(liquidity > 0, "UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED");
        // 铸造流动性给to地址
        _mint(to, liquidity);
        //  更新储备量
        _update(balance0, balance1, _reserve0, _reserve1);
        // 如果有铸造费 ； k = 储备0 * 储备1
        if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
        emit Mint(msg.sender, amount0, amount1);
    }

    // 销毁流动性
    // this low-level function should be called from a contract which performs important safety checks
    function burn(address to) external lock returns (uint amount0, uint amount1) {
        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
        // 获取token0和token1两个代币储备量
        address _token0 = token0;                                // gas savings
        address _token1 = token1;                                // gas savings
        // 获取当前合约中token0和otken1的余额
        uint balance0 = IERC20(_token0).balanceOf(address(this));
        uint balance1 = IERC20(_token1).balanceOf(address(this));
        // 从当前和合约的balanceOf映射中获取当前合约自身流动性数量
        // 当前合约的余额是用户通过合约发送到pair合约要销毁的金额
        uint liquidity = balanceOf[address(this)];

        // 铸造费开关
        bool feeOn = _mintFee(_reserve0, _reserve1);
        uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
        // amount0和amount1是用户能取出来多少的数额
        // amount0 = 流动性数量 * 余额0 / totalSuopply 使用余额确保比例分配
        amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
        amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
        // 两个可取出来的余额必须大于0
        require(amount0 > 0 && amount1 > 0, "UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED");
        // 销毁当前流动性
        _burn(address(this), liquidity);
        // 将amount0数量的token0返回给to地址
        _safeTransfer(_token0, to, amount0);
        _safeTransfer(_token1, to, amount1);

        // 更新两个token的余额
        balance0 = IERC20(_token0).balanceOf(address(this));
        balance1 = IERC20(_token1).balanceOf(address(this));

        _update(balance0, balance1, _reserve0, _reserve1);
        if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
        emit Burn(msg.sender, amount0, amount1, to);
    }
    /*
    * @dev 交换方法
    * @param amount0Out 输出数额0
    * @param amount1Out 输出数额1
    * @param to to地址
    * @param data 用于回调的数据
    * @notice 应该从执行重要安全检查的合同中调用此低级功能
    * this low-level function should be called from a contract which performs important safety checks
    */
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
        // 交换的数值需大于0
        require(amount0Out > 0 || amount1Out > 0, "UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT");
        // 获取储备量0和储备量1
        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
        // 确认去除的数量不能大于它的储备量
        require(amount0Out < _reserve0 && amount1Out < _reserve1, "UniswapV2: INSUFFICIENT_LIQUIDITY");

        // 初始化变量
        uint balance0;
        uint balance1;
        {
            // scope for _token{0,1}, avoids stack too deep errors
            // 标记_token{ 0, 1 }的作用域，避免堆栈太深
            address _token0 = token0;
            address _token1 = token1;
            // 确保token0和token1 !== to
            require(to != _token0 && to != _token1, "UniswapV2: INVALID_TO");
            //  发送token0代币
            if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
            if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
            // 如果data长度大于0，调用to地址的接口
            // 闪电贷
            if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
            // 获取当前合约中token0和token1的余额
            balance0 = IERC20(_token0).balanceOf(address(this));
            balance1 = IERC20(_token1).balanceOf(address(this));
            console.log("swap balance0",balance0);
            console.log("swap balance1",balance1);
        }
        /**
            if(余额 > 储备0 - amount0Ouut){
                return amount0Out = 余额0 - (储备0 - amount0Out)
            }else{
                return amount0Out = 0 
            }
         */
        uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
        uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
        // 确认 输入 (amount0In || amount1In)  > 0
        require(amount0In > 0 || amount1In > 0, "UniswapV2: INSUFFICIENT_INPUT_AMOUNT");
        { 
            // scope for reserve{0,1}Adjusted, avoids stack too deep errors
            // 调整后的余额 =  余额 * 1000 - (amount0In * 3)
            uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
            uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
            // 确认调整后余额0 * 调整后余额1 >= 储备0 * 储备1 * 1000000
            console.log("balance0Adjusted.mul(balance1Adjusted)", balance0Adjusted.mul(balance1Adjusted));
            console.log("uint(_reserve0).mul(_reserve1).mul(1000**2)", uint(_reserve0).mul(_reserve1).mul(1000**2));
            console.log();
            require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), "UniswapV2: K");
        }
        // 更新储备量
        _update(balance0, balance1, _reserve0, _reserve1);
        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
    }

    // force balances to match reserves
    // 强制让余额 == 储备量。一搬用于出本了溢出的情况下，将多余的余额转给`address(to`上，使余额等于储备量
    /*
    * @dev 强制平衡以匹配储备，按照储备量匹配余额
    * @param to to地址
    */
    function skim(address to) external lock {
        address _token0 = token0; // gas savings
        address _token1 = token1; // gas savings
        _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
        _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
    }

    // force reserves to match balances

    /*
    * @dev 强制储备量与余额匹配，按照余额匹配储备量
    * force reserves to match balances
    */
    function sync() external lock {
        _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
    }
}

contract UniswapV2Factory is IUniswapV2Factory {
    // 平台费收取的地址
    address public feeTo;
    // 可以设置平台费收取地址的地址
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    // 读取initCode UniswapV2Router中使用
    bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(UniswapV2Pair).creationCode));

    constructor(address _feeToSetter) public {
        //  手续费设置员 能够设置手续费的收取地址
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }


    // 创建一组新的交易对，传入的参数是两个token的address。
    function createPair(address tokenA, address tokenB) external returns (address pair) {
        // 确保两个合约地址不是相等
        require(tokenA != tokenB, "UniswapV2: IDENTICAL_ADDRESSES");
        // 排序 因为需要用这两个地址做 盐
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        // 确保地址不能为空
        require(token0 != address(0), "UniswapV2: ZERO_ADDRESS");
        // 确保映射地址不能存在
        require(getPair[token0][token1] == address(0), "UniswapV2: PAIR_EXISTS"); // single check is sufficient
        // 初始化 UniswapV2Pair的字节吗变量，bytecode合约经过变异之后的16进制源码
        bytes memory bytecode = type(UniswapV2Pair).creationCode;
        console.log("create Pair bytecode bottom");
        console.log(bytecode);
        // 把排序后的token0和token1打成hash, 用作create2 的 随机盐
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        console.log("bytes1(0xff)", bytes1(0xff));
        assembly {
            // 通过create2 预测合约地址
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        // 调用pair合约。
        IUniswapV2Pair(pair).initialize(token0, token1);
        // 把已经创建的和余额插入map中
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }
    // 设置平台手续费收取地址
    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, "UniswapV2: FORBIDDEN");
        feeTo = _feeTo;
    }
    // 设置平台手续费权限控制人
    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, "UniswapV2: FORBIDDEN");
        feeToSetter = _feeToSetter;
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

// a library for performing various math operations

library Math {
    function min(uint x, uint y) internal pure returns (uint z) {
        z = x < y ? x : y;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))

// range: [0, 2**112 - 1]
// resolution: 1 / 2**112

library UQ112x112 {
    uint224 constant Q112 = 2**112;

    // encode a uint112 as a UQ112x112
    function encode(uint112 y) internal pure returns (uint224 z) {
        z = uint224(y) * Q112; // never overflows
    }

    // divide a UQ112x112 by a uint112, returning a UQ112x112
    function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
        z = x / uint224(y);
    }
}