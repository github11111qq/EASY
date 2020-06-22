contract Easy{


struct User {

    uint256 pID;
    uint256 affId;
    uint256 level;    
    uint256 invites;
    uint256 totalBet;
    uint256 lastBet;
    uint256 lastReleaseTime;

    
}


struct bestBet{
    uint256 pid;
    uint256 eth;
    uint256 datetime;
}


struct gdUser {
    uint256 pId;
    uint256 level;
      
        
}



bool public activated_ = true;
uint256 ethWei = 1 ether;

uint256 public tokenBuyId_;
uint256 public jSId_;
uint256  genReleTime_ = 1 days; 

uint256 public maxBigPot_ = 50000 * ethWei;
uint256 public bigPot_;
uint256 public bigPotStartTime;
uint256 public bigPotTime_ = 24 hours;
uint256 public bigPotMt_ = 3 hours;


mapping (string   => uint256) public pIDInviteCode_;
mapping (address => uint256)   public pIDxAddr_;
mapping (uint256 => User)    public plyr_;  
mapping (uint256 => Tes) public ts_;
mapping (uint256 => Earnings) public es_;
mapping (uint256 => jsHistory) public  jsHistory_;
mapping (uint256 => betHistory) public betHistory_;
mapping (uint256 => levelReward) public levelReward_; 


 function buyToken()
        isActivated()
        isHuman()
        public
        payable
{
    if(msg.value > 0){
        determinePID(msg.sender,"");
        uint256 _pID = pIDxAddr_[msg.sender];
        
        uint256 _price = eToken_.getBuyPrice();
        uint256 _num = msg.value *  _price / 1e18;
        
        eToken_.sellToken(msg.sender,_num);
        
        tks_.transfer(msg.value);

        if(msg.value >= 100* ethWei){

            plyr_[_pID].isDs = true;
        }
        

        
        tokenHistory memory _t;
        _t.pid = _pID;
        _t.datetime = now;
        _t.token = _num;
        tokenHistory_[tokenBuyId_] = _t;
        tokenBuyId_++;
       

    }
        
}

     

function buyCore(uint256 _pID,uint256 _eth)
    isCanBet(_pID,_eth)
    private
{
    
    if(plyr_[_pID].totalBet == 0){
        
        plyr_[_pID].firbetTime = now;
        ThSmallQue_[smallRoud_].push(_pID);
    }
 
    
    if(now - bigPotStartTime >= bigPotTime_){
        
    
        bigPot_ = 0;
    }


    if(_eth>0){
        bs_.transfer(_eth.mul(3)/100);
        uint256 _bigPot = _eth.mul(10)/100;
        
        if(bigPot_ < maxBigPot_){
            bp_.transfer(_bigPot);
        }

        bigPot_ = bigPot_.add(_bigPot);

        bigPotStartTime = bigPotStartTime + getBigTime(_eth);
        
        
    }

    

    cmPot(_eth);
    JsDs(_pID,_eth,0,0,0);
    
   
    smallPot_ = smallPot_ + _eth.mul(3)/100;
    
    bestBestQue_[smallRoud_][_pID] = bestBestQue_[smallRoud_][_pID] + _eth;
    
   if(bestBestQue_[smallRoud_][_pID] > bestBetHis_[smallRoud_].eth){
        bestBetHis_[smallRoud_].pid = _pID;
        bestBetHis_[smallRoud_].eth = bestBestQue_[smallRoud_][_pID];
        bestBetHis_[smallRoud_].datetime = now;
    }

    if(plyr_[_pID].affId > 0){
        drUserBet_[smallRoud_][plyr_[_pID].affId] = drUserBet_[smallRoud_][plyr_[_pID].affId].add(_eth);
        statisticalDirBet(plyr_[_pID].affId);
        
         
    }
    
    

    plyr_[_pID].level = getLevel(_eth);
    plyr_[_pID].lastReleaseTime = now;

    gBet_ = gBet_.add(_eth);
    gBetcc_= gBetcc_ + 1; 
    
   
}




function setOrder (uint256 _pID,uint256 _eth) private returns(uint256 _orderid) {

    _orderid = orderId_;

    betHistory memory  _history;
    _history.pID = _pID;
    _history.betTime = now;
    _history.eth = _eth;
 

    betHistory_[_orderid] = _history;
    orderId_++;
}


function getLevel (uint256 _betEth) 
public
view
returns(uint8 level) 
{
    uint8 _level = 0;
    if(_betEth>=31 * ethWei){
        _level = 3;

    }else if(_betEth>=11 * ethWei){
        _level = 2;

    }else if(_betEth>=1 * ethWei){
        _level = 1;

    }
    return _level;
}



function getEth() 
public
{

address payable _addr = msg.sender;
uint256 _pID = pIDxAddr_[_addr];

if(now - bigPotStartTime >= bigPotTime_){
    bigPotStartTime = now;
    bigPot_ = 0;
}
        
smallPot();
uint256 _eth = unwdUser_[_pID].ugen +  unwdUser_[_pID].ugs +   es_[_pID].genE  + es_[_pID].smallpot + es_[_pID].gsE;



if(_eth>= 1e16)
 {
   
    es_[_pID].genE = 0;
    
    unwdUser_[_pID].ugen = 0;
    
    es_[_pID].smallpot = 0;
    es_[_pID].gsE = 0;
    unwdUser_[_pID].ugs = 0;
    
    es_[_pID].wd += _eth; 
    es_[_pID].wdGG = es_[_pID].wdGG + es_[_pID].genE + es_[_pID].gsE;
    _addr.transfer(_eth);

    
 }

}


function getAffEth() 
public
{

address payable _addr = msg.sender;
uint256 _pID = pIDxAddr_[_addr];
 

uint256 _eth = unwdUser_[_pID].uaff +  es_[_pID].affE ;



if(_eth>= 1e16)
 {
   

 
    es_[_pID].affE = 0;
    unwdUser_[_pID].uaff = 0;
    es_[_pID].wd += _eth; 
    es_[_pID].wdGG = es_[_pID].wdGG  + es_[_pID].affE;
    _addr.transfer(_eth);

    
 }

}


function getAmEth() 
public
{

address payable _addr = msg.sender;
uint256 _pID = pIDxAddr_[_addr];
 

uint256 _eth = unwdUser_[_pID].uam +  es_[_pID].amE;


if(_eth>= 1e16)
 {
 
    es_[_pID].amE = 0;
    unwdUser_[_pID].uam =0 ;
    es_[_pID].wd += _eth; 
    es_[_pID].wdGG = es_[_pID].wdGG  + es_[_pID].amE;
    _addr.transfer(_eth);

    
 }

}

function getCmEth() 
public
{

address payable _addr = msg.sender;
uint256 _pID = pIDxAddr_[_addr];
 

uint256 _eth = unwdUser_[_pID].ucm +   es_[_pID].cmE;


if(_eth>= 1e16)
 {
    es_[_pID].cmE = 0;
    unwdUser_[_pID].ucm = 0;
    es_[_pID].wd += _eth; 
    es_[_pID].wdGG = es_[_pID].wdGG  + es_[_pID].cmE;
    _addr.transfer(_eth);

    
 }

}


function getExcellenceUser (uint256 _rid,uint256 _weizhi) 
public
view
returns(uint256 _pID,uint256 _totalBet,uint256 _baseAff) 
{
     _pID = drBestQue_[_rid][_weizhi];
    return
    (
        _pID,
        plyr_[_pID].totalBet,
        drUserBet_[_rid][_pID]

    );
}
function getsystemMsg()
public
view
returns(uint256 _gbet,uint256 _gcc,uint256 _totalSupply,uint256 _totalDestroy,uint256 _totalSellNum,uint256 _startime,uint256 _qs,
uint256 _smallpot,uint256 _smallpottime,uint256 _bigpot,uint256 _bigpottime,address _maxbetaddr,uint256 _maxbeteth)
{
  ( _totalSupply, _totalDestroy, _totalSellNum,_startime,_qs) = eToken_.totalOfContact();
    return
    (
        gBet_,
        gBetcc_,
        _totalSupply,
        _totalDestroy,
        _totalSellNum,
        _startime,
        _qs,
        smallPot_,
        smallPotStartTime + smallTime_,
        bigPot_,
        bigPotStartTime + bigPotTime_,
        plyr_[bestBetHis_[smallRoud_].pid].addr,
        bestBetHis_[smallRoud_].eth
        
        
        
    );
}

function getUserInfo(uint256 _pid) view public returns(uint256 _reward,uint256 _genE,uint256 _affE, uint256 _level,bool _isDs,uint256 _gen,address _affAddr,uint256 _firBetTime,string memory _affIcode){
    
    (_gen,) = getUserRewardByBase( _pid);
    _reward = plyr_[_pid].reward;
    _genE = es_[_pid].genE;
    _affE =  es_[_pid].affE;
    _level =  gd_[plyr_[_pid].gdNum].level;
    _isDs =   plyr_[_pid].isDs;
    _affAddr = plyr_[plyr_[_pid].affId].addr;
    _firBetTime = plyr_[_pid].firbetTime;
    _affIcode = plyr_[plyr_[_pid].affId].inviteCode;
  
}

function getTokenPrice()view public returns(uint256 _price){
    _price = eToken_.getBuyPrice();
}

function getAddreToken (address _addr) view public returns(uint256 _token) {
    _token = eToken_.balanceOfAddr(_addr);
}
