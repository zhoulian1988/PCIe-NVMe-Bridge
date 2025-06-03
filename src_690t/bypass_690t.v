module bypass_690t #(
/*
*/
parameter DNA_ID     = 57'h1C28C43D6219248,//hxzy yun2 FPGA (jfm)
                     //57'h1C10243D1461243
                    //57'h1C38303D1461243
                    //57'h1808A73D1461243                  
parameter DNA_BIT_CNT= 8'd76, // notice  xilinx : 75, jfm: 76
// ep and rp
parameter          C_DATA_WIDTH                        = 128,         // RX/TX interface data width
parameter          KEEP_WIDTH                          = C_DATA_WIDTH / 32,


// USER_CLK2_FREQ = AXI Interface Frequency
//   0: Disable User Clock
//   1: 31.25 MHz
//   2: 62.50 MHz  (default)
//   3: 125.00 MHz
//   4: 250.00 MHz
//   5: 500.00 MHz
parameter  integer USER_CLK2_FREQ                 = 3,

parameter          REF_CLK_FREQ                   = 0,           // 0 - 100 MHz, 1 - 125 MHz,  2 - 250 MHz
//ep
parameter          PL_SIM_FAST_LINK_TRAINING           = "FALSE",      // Simulation Speedup
parameter          PCIE_EXT_CLK                        = "FALSE", // Use External Clocking Module
parameter          PCIE_EXT_GT_COMMON                  = "FALSE", // Use External GT COMMON Module
// parameter          EXT_PIPE_SIM                        = "FALSE",  // This Parameter has effect on selecting Enable External PIPE Interface in GUI.
parameter          PL_LINK_CAP_MAX_LINK_SPEED          = 2,  // 1- GEN1, 2 - GEN2, 4 - GEN3
parameter          PL_LINK_CAP_MAX_LINK_WIDTH          = 4,  // 1- X1, 2 - X2, 4 - X4, 8 - X8

parameter          AXISTEN_IF_RQ_ALIGNMENT_MODE   = "FALSE",
parameter          AXISTEN_IF_CC_ALIGNMENT_MODE   = "FALSE",
parameter          AXISTEN_IF_CQ_ALIGNMENT_MODE   = "FALSE",
parameter          AXISTEN_IF_RC_ALIGNMENT_MODE   = "FALSE",
parameter          AXISTEN_IF_ENABLE_CLIENT_TAG   = 1,
parameter          AXISTEN_IF_RQ_PARITY_CHECK     = 0,
parameter          AXISTEN_IF_CC_PARITY_CHECK     = 0,
parameter          AXISTEN_IF_MC_RX_STRADDLE      = 0,
parameter          AXISTEN_IF_ENABLE_RX_MSG_INTFC = 0,
parameter   [17:0] AXISTEN_IF_ENABLE_MSG_ROUTE    = 18'h2FFFF,
//rp
//    parameter          EXT_PIPE_SIM                 = "FALSE",        // This Parameter has effect on selecting Enable External PIPE Interface in GUI.
//    parameter          PL_LINK_CAP_MAX_LINK_SPEED   = 2,  // 1- GEN1, 2 - GEN2, 4 - GEN3, 8 - GEN4
//    parameter [4:0]    PL_LINK_CAP_MAX_LINK_WIDTH   = 4,  // 1- X1, 2 - X2, 4 - X4, 8 - X8, 16 - X16
    parameter          PL_DISABLE_EI_INFER_IN_L0    = "TRUE",
    
    //parameter          ROM_FILE                   = "cgator_cfg_rom_yh_server_samsung_pm961.data",  // gen3 different from gen2 data format
    //parameter          ROM_FILE                   = "cgator_cfg_rom_yh_server_veiglo_xmc.data",  // gen3 different from gen2 data format
    //parameter          ROM_FILE                     = "cgator_cfg_rom_yh_server_dera_tai0001.data",  // gen3 different from gen2 data format
    
    parameter          ROM_FILE                     = "cgator_cfg_rom_yh_server_veiglo_xmc.data",  // gen3 different from gen2 data format
    parameter          ROM_SIZE                     = 32,  //jzhang 2023.03.15 add Completion timeout and disable Extended Tag
    
    parameter [15:0]   REQUESTER_ID                 = 16'h0000, //jzhang 2022.11.19   
    parameter [7:0]    BUSNUMBER                    = 8'h01,                                                             
//  USER_CLK[1/2]_FREQ        : 0 = Disable user clock
//                                : 1 =  31.25 MHz
//                                : 2 =  62.50 MHz (default)
//                                : 3 = 125.00 MHz
//                                : 4 = 250.00 MHz
//                                : 5 = 500.00 MHz
    parameter PL_DISABLE_UPCONFIG_CAPABLE           = "FALSE",
//  parameter USER_CLK2_DIV2                      = "FALSE",         // "FALSE" => user_clk2 = user_clk

//    parameter        AXISTEN_IF_RQ_ALIGNMENT_MODE   = "FALSE",
//    parameter        AXISTEN_IF_CC_ALIGNMENT_MODE   = "FALSE",
//    parameter        AXISTEN_IF_CQ_ALIGNMENT_MODE   = "FALSE",
//    parameter        AXISTEN_IF_RC_ALIGNMENT_MODE   = "FALSE",
  
//    parameter        AXISTEN_IF_ENABLE_CLIENT_TAG   = "TRUE",
//    parameter        AXISTEN_IF_RQ_PARITY_CHECK     = "FALSE",
//    parameter        AXISTEN_IF_CC_PARITY_CHECK     = "FALSE",
//    parameter        AXISTEN_IF_MC_RX_STRADDLE      = "FALSE",
//    parameter        AXISTEN_IF_ENABLE_RX_MSG_INTFC = "FALSE",
//    parameter [17:0] AXISTEN_IF_ENABLE_MSG_ROUTE    = 18'h2FFFF,

// Ultrascale +
// parameter        AXI4_CQ_TUSER_WIDTH            = 88,
// parameter        AXI4_CC_TUSER_WIDTH            = 33,
// parameter        AXI4_RQ_TUSER_WIDTH            = 62,
// parameter        AXI4_RC_TUSER_WIDTH            = 75,
    parameter   DNA_EN                  = 1'b0,  
// DNA_EN = 1: Enable  dna code. if missing match, System cannot run.                                                                                    
// DNA_EN = 0: disable dna code. 

// V7 690T 
    parameter        AXI4_CQ_TUSER_WIDTH            = 85,
    parameter        AXI4_CC_TUSER_WIDTH            = 33,
    parameter        AXI4_RQ_TUSER_WIDTH            = 60,
    parameter        AXI4_RC_TUSER_WIDTH            = 75

)
(
  output  [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  ep_pci_exp_txp,
  output  [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  ep_pci_exp_txn,
  input   [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  ep_pci_exp_rxp,
  input   [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  ep_pci_exp_rxn,

  input                                           ep_sys_clk_p,
  input                                           ep_sys_clk_n,

  input                                           ep_sys_rst_n,

  output  [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  rp_pci_exp_txp,
  output  [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  rp_pci_exp_txn,
  input   [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  rp_pci_exp_rxp,
  input   [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0]  rp_pci_exp_rxn,

  input                                           rp_sys_clk_p,
  input                                           rp_sys_clk_n,
  
  input 						                  clk100_p,
  input                                           clk100_n,

  output  reg [1:0]                               led
  
);

wire clk100;


     IBUFGDS #(
         .DIFF_TERM("FALSE"),       // Differential Termination
         .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
         .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
      ) IBUFGDS_inst (
         .O(clk100),  // Buffer output
         .I(clk100_p),  // Diff_p buffer input (connect directly to top-level port)
         .IB(clk100_n) // Diff_n buffer input (connect directly to top-level port)
      );

  wire      dna_ok_flag;
  wire      finished_config; 
  wire      failed_config;  
  
  wire      rp_sys_rst_n;
  wire      ep_sys_rst_n;

assign rp_sys_rst_n = ep_sys_rst_n;

//assign rp_to_J8_sys_rst_n = ep_sys_rst_n;

 
  //----------------------------------------------------------------------------------------------------------------//
  //  AXI Interface                  ep                                                                             //
  //----------------------------------------------------------------------------------------------------------------//
  wire                                     ep_s_axis_rq_tlast;
  wire              [C_DATA_WIDTH-1:0]     ep_s_axis_rq_tdata;
  wire       [AXI4_RQ_TUSER_WIDTH-1:0]     ep_s_axis_rq_tuser;
  wire                [KEEP_WIDTH-1:0]     ep_s_axis_rq_tkeep;
  wire                                     ep_s_axis_rq_tready;
  wire                                     ep_s_axis_rq_tvalid;

  wire               [C_DATA_WIDTH-1:0]    ep_m_axis_rc_tdata;
  wire        [AXI4_RC_TUSER_WIDTH-1:0]    ep_m_axis_rc_tuser;
  wire                                     ep_m_axis_rc_tlast;
  wire                 [KEEP_WIDTH-1:0]    ep_m_axis_rc_tkeep;
  wire                                     ep_m_axis_rc_tvalid;
  wire                                     ep_m_axis_rc_tready;

  wire               [C_DATA_WIDTH-1:0]    ep_m_axis_cq_tdata;
  wire        [AXI4_CQ_TUSER_WIDTH-1:0]    ep_m_axis_cq_tuser;
  wire                                     ep_m_axis_cq_tlast;
  wire                 [KEEP_WIDTH-1:0]    ep_m_axis_cq_tkeep;
  wire                                     ep_m_axis_cq_tvalid;
  wire                                     ep_m_axis_cq_tready;

  wire              [C_DATA_WIDTH-1:0]     ep_s_axis_cc_tdata;
  wire       [AXI4_CC_TUSER_WIDTH-1:0]     ep_s_axis_cc_tuser;
  wire                                     ep_s_axis_cc_tlast;
  wire                [KEEP_WIDTH-1:0]     ep_s_axis_cc_tkeep;
  wire                                     ep_s_axis_cc_tvalid;
  wire                                     ep_s_axis_cc_tready;

  wire					                   ep_user_clk;
  wire					                   ep_user_reset;
  wire					                   ep_user_lnk_up;
  wire                                     ep_cfg_err_cor_out;
  wire                                     ep_cfg_err_nonfatal_out;
  wire                                     ep_cfg_err_fatal_out;


  //----------------------------------------------------------------------------------------------------------------//
  //  AXI Interface                  rp                                                                             //
  //----------------------------------------------------------------------------------------------------------------//
  wire                                     rp_s_axis_rq_tlast;
  wire              [C_DATA_WIDTH-1:0]     rp_s_axis_rq_tdata;
  wire       [AXI4_RQ_TUSER_WIDTH-1:0]     rp_s_axis_rq_tuser;
  wire                [KEEP_WIDTH-1:0]     rp_s_axis_rq_tkeep;
  wire                                     rp_s_axis_rq_tready;
  wire                                     rp_s_axis_rq_tvalid;

  wire               [C_DATA_WIDTH-1:0]    rp_m_axis_rc_tdata;
  wire        [AXI4_RC_TUSER_WIDTH-1:0]    rp_m_axis_rc_tuser;
  wire                                     rp_m_axis_rc_tlast;
  wire                 [KEEP_WIDTH-1:0]    rp_m_axis_rc_tkeep;
  wire                                     rp_m_axis_rc_tvalid;
  wire                                     rp_m_axis_rc_tready;

  wire               [C_DATA_WIDTH-1:0]    rp_m_axis_cq_tdata;
  wire        [AXI4_CQ_TUSER_WIDTH-1:0]    rp_m_axis_cq_tuser;
  wire                                     rp_m_axis_cq_tlast;
  wire                 [KEEP_WIDTH-1:0]    rp_m_axis_cq_tkeep;
  wire                                     rp_m_axis_cq_tvalid;
  wire                                     rp_m_axis_cq_tready;

  wire              [C_DATA_WIDTH-1:0]     rp_s_axis_cc_tdata;
  wire       [AXI4_CC_TUSER_WIDTH-1:0]     rp_s_axis_cc_tuser;
  wire                                     rp_s_axis_cc_tlast;
  wire                [KEEP_WIDTH-1:0]     rp_s_axis_cc_tkeep;
  wire                                     rp_s_axis_cc_tvalid;
  wire                                     rp_s_axis_cc_tready;

  wire					                   rp_user_clk;
  wire					                   rp_user_reset;
  wire					                   rp_user_lnk_up;
  
  wire                                     rp_cfg_err_cor_out;
  wire                                     rp_cfg_err_nonfatal_out;
  wire                                     rp_cfg_err_fatal_out;

ep  #(
/*
*/
  .PL_LINK_CAP_MAX_LINK_WIDTH     (PL_LINK_CAP_MAX_LINK_WIDTH),  // 1- X1, 2 - X2, 4 - X4, 8 - X8, 16 - X16
  .C_DATA_WIDTH                   (C_DATA_WIDTH),         // RX/TX interface data width
  .AXISTEN_IF_MC_RX_STRADDLE      (AXISTEN_IF_MC_RX_STRADDLE),
  .PL_LINK_CAP_MAX_LINK_SPEED     (PL_LINK_CAP_MAX_LINK_SPEED),  // 1- GEN1, 2 - GEN2, 4 - GEN3, 8 - GEN4
  .KEEP_WIDTH                     (KEEP_WIDTH),
  //.EXT_PIPE_SIM                   (EXT_PIPE_SIM),  // This Parameter has effect on selecting Enable External PIPE Interface in GUI.
  .AXISTEN_IF_CC_ALIGNMENT_MODE   (AXISTEN_IF_CC_ALIGNMENT_MODE),
  .AXISTEN_IF_CQ_ALIGNMENT_MODE   (AXISTEN_IF_CQ_ALIGNMENT_MODE),
  .AXISTEN_IF_RQ_ALIGNMENT_MODE   (AXISTEN_IF_RQ_ALIGNMENT_MODE),
  .AXISTEN_IF_RC_ALIGNMENT_MODE   (AXISTEN_IF_RC_ALIGNMENT_MODE),
  .AXI4_CQ_TUSER_WIDTH            (AXI4_CQ_TUSER_WIDTH),
  .AXI4_CC_TUSER_WIDTH            (AXI4_CC_TUSER_WIDTH),
  .AXI4_RQ_TUSER_WIDTH            (AXI4_RQ_TUSER_WIDTH),
  .AXI4_RC_TUSER_WIDTH            (AXI4_RC_TUSER_WIDTH),
  .AXISTEN_IF_ENABLE_CLIENT_TAG   ("TRUE"),
  //.RQ_AVAIL_TAG_IDX               (RQ_AVAIL_TAG_IDX),
  //.RQ_AVAIL_TAG                   (RQ_AVAIL_TAG),
  .AXISTEN_IF_RQ_PARITY_CHECK     (AXISTEN_IF_RQ_PARITY_CHECK),
  .AXISTEN_IF_CC_PARITY_CHECK     (AXISTEN_IF_CC_PARITY_CHECK),
  //.AXISTEN_IF_RC_PARITY_CHECK     (AXISTEN_IF_RC_PARITY_CHECK),
  //.AXISTEN_IF_CQ_PARITY_CHECK     (AXISTEN_IF_CQ_PARITY_CHECK),
  .AXISTEN_IF_ENABLE_RX_MSG_INTFC (AXISTEN_IF_ENABLE_RX_MSG_INTFC),
  .AXISTEN_IF_ENABLE_MSG_ROUTE    (AXISTEN_IF_ENABLE_MSG_ROUTE)

) 
ep_i (
  .pci_exp_txp                                   (ep_pci_exp_txp),
  .pci_exp_txn                                   (ep_pci_exp_txn),
  .pci_exp_rxp                                   (ep_pci_exp_rxp),
  .pci_exp_rxn                                   (ep_pci_exp_rxn),

  .sys_clk_p                                     (ep_sys_clk_p),
  .sys_clk_n                                     (ep_sys_clk_n),

  .sys_rst_n                                     (ep_sys_rst_n),

  .s_axis_cc_tdata                                ( ep_s_axis_cc_tdata ),
  .s_axis_cc_tkeep                                ( ep_s_axis_cc_tkeep ),
  .s_axis_cc_tlast                                ( ep_s_axis_cc_tlast ),
  .s_axis_cc_tvalid                               ( ep_s_axis_cc_tvalid ),
  .s_axis_cc_tuser                                ( ep_s_axis_cc_tuser ),
  .s_axis_cc_tready                               ( ep_s_axis_cc_tready ),

  .s_axis_rq_tdata                                ( ep_s_axis_rq_tdata ),
  .s_axis_rq_tkeep                                ( ep_s_axis_rq_tkeep ),
  .s_axis_rq_tlast                                ( ep_s_axis_rq_tlast ),
  .s_axis_rq_tvalid                               ( ep_s_axis_rq_tvalid ),
  .s_axis_rq_tuser                                ( ep_s_axis_rq_tuser ),
  .s_axis_rq_tready                               ( ep_s_axis_rq_tready ),

  .m_axis_cq_tdata                                ( ep_m_axis_cq_tdata ),
  .m_axis_cq_tlast                                ( ep_m_axis_cq_tlast ),
  .m_axis_cq_tvalid                               ( ep_m_axis_cq_tvalid ),
  .m_axis_cq_tuser                                ( ep_m_axis_cq_tuser ),
  .m_axis_cq_tkeep                                ( ep_m_axis_cq_tkeep ),
  .m_axis_cq_tready                               ( ep_m_axis_cq_tready ),

  .m_axis_rc_tdata                                ( ep_m_axis_rc_tdata ),
  .m_axis_rc_tlast                                ( ep_m_axis_rc_tlast ),
  .m_axis_rc_tvalid                               ( ep_m_axis_rc_tvalid ),
  .m_axis_rc_tuser                                ( ep_m_axis_rc_tuser ),
  .m_axis_rc_tkeep                                ( ep_m_axis_rc_tkeep ),
  .m_axis_rc_tready                               ( ep_m_axis_rc_tready ),

  .user_clk                                       ( ep_user_clk ),
  .user_reset                                     ( ep_user_reset ),
  .user_lnk_up                                    ( ep_user_lnk_up ),
  .cfg_err_cor_out                                ( ep_cfg_err_cor_out),
  .cfg_err_nonfatal_out                           ( ep_cfg_err_nonfatal_out),
  .cfg_err_fatal_out                              ( ep_cfg_err_fatal_out)

);


rp  #(
/*
*/
    .PCIE_EXT_CLK                   (PCIE_EXT_CLK),
.C_DATA_WIDTH                   (C_DATA_WIDTH),            // RX/TX interface data width
//.EXT_PIPE_SIM                   (EXT_PIPE_SIM),                                // This Parameter has effect on selecting Enable External PIPE Interface in GUI.
.PL_LINK_CAP_MAX_LINK_SPEED     (PL_LINK_CAP_MAX_LINK_SPEED),  // 1- GEN1, 2 - GEN2, 4 - GEN3, 8 - GEN4
.PL_LINK_CAP_MAX_LINK_WIDTH     (PL_LINK_CAP_MAX_LINK_WIDTH),  // 1- X1, 2 - X2, 4 - X4, 8 - X8, 16 - X16
.PL_DISABLE_EI_INFER_IN_L0      (PL_DISABLE_EI_INFER_IN_L0),
.ROM_FILE                       (ROM_FILE),
.ROM_SIZE                       (ROM_SIZE),
.REQUESTER_ID                   (REQUESTER_ID),
.BUSNUMBER                      (BUSNUMBER),
//  USER_CLK[1/2]_FREQ        : 0 = Disable user clock
//                                : 1 =  31.25 MHz
//                                : 2 =  62.50 MHz (default)
//                                : 3 = 125.00 MHz
//                                : 4 = 250.00 MHz
//                                : 5 = 500.00 MHz
.PL_DISABLE_UPCONFIG_CAPABLE    (PL_DISABLE_UPCONFIG_CAPABLE),
.USER_CLK2_FREQ                 (USER_CLK2_FREQ),
//.USER_CLK2_DIV2                      (USER_CLK2_DIV2),         // "FALSE" => user_clk2 = user_clk
.REF_CLK_FREQ                   (REF_CLK_FREQ),  // 0 - 100 MHz, 1 - 125 MHz,  2 - 250 MHz
.AXISTEN_IF_RQ_ALIGNMENT_MODE   (AXISTEN_IF_RQ_ALIGNMENT_MODE),
.AXISTEN_IF_CC_ALIGNMENT_MODE   (AXISTEN_IF_CC_ALIGNMENT_MODE),
.AXISTEN_IF_CQ_ALIGNMENT_MODE   (AXISTEN_IF_CQ_ALIGNMENT_MODE),
.AXISTEN_IF_RC_ALIGNMENT_MODE   (AXISTEN_IF_RC_ALIGNMENT_MODE),
.AXI4_CQ_TUSER_WIDTH            (AXI4_CQ_TUSER_WIDTH),
.AXI4_CC_TUSER_WIDTH            (AXI4_CC_TUSER_WIDTH),
.AXI4_RQ_TUSER_WIDTH            (AXI4_RQ_TUSER_WIDTH),
.AXI4_RC_TUSER_WIDTH            (AXI4_RC_TUSER_WIDTH),
.AXISTEN_IF_ENABLE_CLIENT_TAG   ("TRUE"),
.AXISTEN_IF_RQ_PARITY_CHECK     (AXISTEN_IF_RQ_PARITY_CHECK),
.AXISTEN_IF_CC_PARITY_CHECK     (AXISTEN_IF_CC_PARITY_CHECK),
.AXISTEN_IF_MC_RX_STRADDLE      (AXISTEN_IF_MC_RX_STRADDLE),
.AXISTEN_IF_ENABLE_RX_MSG_INTFC (AXISTEN_IF_ENABLE_RX_MSG_INTFC),
.AXISTEN_IF_ENABLE_MSG_ROUTE    (AXISTEN_IF_ENABLE_MSG_ROUTE),
.KEEP_WIDTH                     (KEEP_WIDTH),
.DNA_EN                         (DNA_EN)
) 
rp_i (
  .pci_exp_txp  (rp_pci_exp_txp),
  .pci_exp_txn  (rp_pci_exp_txn),
  .pci_exp_rxp  (rp_pci_exp_rxp),
  .pci_exp_rxn  (rp_pci_exp_rxn),


  .sys_clk_p    (rp_sys_clk_p),
  .sys_clk_n    (rp_sys_clk_n),

  .sys_rst_n    (rp_sys_rst_n),

  .s_axis_cc_tdata                                ( rp_s_axis_cc_tdata ),
  .s_axis_cc_tkeep                                ( rp_s_axis_cc_tkeep ),
  .s_axis_cc_tlast                                ( rp_s_axis_cc_tlast ),
  .s_axis_cc_tvalid                               ( rp_s_axis_cc_tvalid ),
  .s_axis_cc_tuser                                ( rp_s_axis_cc_tuser ),
  .s_axis_cc_tready                               ( rp_s_axis_cc_tready ),

  .s_axis_rq_tdata                                ( rp_s_axis_rq_tdata ),
  .s_axis_rq_tkeep                                ( rp_s_axis_rq_tkeep ),
  .s_axis_rq_tlast                                ( rp_s_axis_rq_tlast ),
  .s_axis_rq_tvalid                               ( rp_s_axis_rq_tvalid ),
  .s_axis_rq_tuser                                ( rp_s_axis_rq_tuser ),
  .s_axis_rq_tready                               ( rp_s_axis_rq_tready ),

  .m_axis_cq_tdata                                ( rp_m_axis_cq_tdata ),
  .m_axis_cq_tlast                                ( rp_m_axis_cq_tlast ),
  .m_axis_cq_tvalid                               ( rp_m_axis_cq_tvalid ),
  .m_axis_cq_tuser                                ( rp_m_axis_cq_tuser ),
  .m_axis_cq_tkeep                                ( rp_m_axis_cq_tkeep ),
  .m_axis_cq_tready                               ( rp_m_axis_cq_tready ),

  .m_axis_rc_tdata                                ( rp_m_axis_rc_tdata ),
  .m_axis_rc_tlast                                ( rp_m_axis_rc_tlast ),
  .m_axis_rc_tvalid                               ( rp_m_axis_rc_tvalid ),
  .m_axis_rc_tuser                                ( rp_m_axis_rc_tuser ),
  .m_axis_rc_tkeep                                ( rp_m_axis_rc_tkeep ),
  .m_axis_rc_tready                               ( rp_m_axis_rc_tready ),

  .user_clk                                       ( rp_user_clk ),
  .user_reset                                     ( rp_user_reset ),
  .user_lnk_up                                    ( rp_user_lnk_up ),
  .cfg_err_cor_out                                ( rp_cfg_err_cor_out),
  .cfg_err_nonfatal_out                           ( rp_cfg_err_nonfatal_out),
  .cfg_err_fatal_out                              ( rp_cfg_err_fatal_out),
  .finished_config                                (finished_config),
  .failed_config                                  (failed_config),
  .dna_ok_flag                                    (dna_ok_flag)
);


//----------------------------------------------------------------------------------------------------------------//
//  ep_cq_to_rp_rq_fifo                tvalid   tlast    tdata      tkeep     cq_tuser                              //
//                                        1  +   1    +   128    +    4     +   85    =   219                     //
//                                      [218]   [217]   [216:89]   [88:85]    [84:0]                              //
//----------------------------------------------------------------------------------------------------------------//
	wire         							ep_cq_to_rp_rq_fifo_rst;
	wire         							ep_cq_to_rp_rq_fifo_wr_clk;
	wire         							ep_cq_to_rp_rq_fifo_wr_en;
	wire 	[218:0] 						ep_cq_to_rp_rq_fifo_din;   // 1  +   1    +  128  +   4   +  85  = 219
	wire         							ep_cq_to_rp_rq_fifo_full;
	wire         							ep_cq_to_rp_rq_fifo_prog_full;


	wire         							ep_cq_to_rp_rq_fifo_rd_clk;
	wire         							ep_cq_to_rp_rq_fifo_rd_en;
	//reg                                     ep_cq_to_rp_rq_fifo_rd_en;
	wire         							ep_cq_to_rp_rq_fifo_valid;
	wire 	[218:0] 						ep_cq_to_rp_rq_fifo_dout;  // 1  +   1    +  128  +   4   +  85  = 219
	wire         							ep_cq_to_rp_rq_fifo_empty;

ep_cq_to_rp_rq_fifo ep_cq_to_rp_rq_fifo_i (
	.rst       							(ep_cq_to_rp_rq_fifo_rst),
	.wr_clk    							(ep_cq_to_rp_rq_fifo_wr_clk),
	.wr_en     							(ep_cq_to_rp_rq_fifo_wr_en),
	.din       							(ep_cq_to_rp_rq_fifo_din),  // 1  +   1    +  128  +   4   +  85  = 219     
	.full      							(ep_cq_to_rp_rq_fifo_full),
	.prog_full 							(ep_cq_to_rp_rq_fifo_prog_full),
	.wr_rst_busy 							(),

	.rd_clk   							(ep_cq_to_rp_rq_fifo_rd_clk),
	.rd_en    							(ep_cq_to_rp_rq_fifo_rd_en),
	.valid    							(ep_cq_to_rp_rq_fifo_valid),
	.dout     							(ep_cq_to_rp_rq_fifo_dout),  // 1  +   1    +  128  +   4   +  85  = 219
	.empty    							(ep_cq_to_rp_rq_fifo_empty),
	.rd_rst_busy 							()
);

assign ep_cq_to_rp_rq_fifo_rst    = ep_user_reset;
assign ep_cq_to_rp_rq_fifo_wr_clk = ep_user_clk;
assign ep_cq_to_rp_rq_fifo_wr_en  = ep_m_axis_cq_tvalid & ep_m_axis_cq_tready;
assign ep_cq_to_rp_rq_fifo_din    = {ep_m_axis_cq_tvalid, ep_m_axis_cq_tlast, ep_m_axis_cq_tdata, ep_m_axis_cq_tkeep, ep_m_axis_cq_tuser};
assign ep_m_axis_cq_tready        = ~ep_cq_to_rp_rq_fifo_prog_full;


reg [1:0] ep_cq_to_rp_rq_fifo_rd_en_delay_cycle;

assign ep_cq_to_rp_rq_fifo_rd_clk = rp_user_clk;
assign ep_cq_to_rp_rq_fifo_rd_en  = rp_s_axis_rq_tready & (ep_cq_to_rp_rq_fifo_rd_en_delay_cycle == 2'd0);

	wire 		ep_cq_to_rp_rq_fifo_dout_tvalid_w;
	wire 		ep_cq_to_rp_rq_fifo_dout_tlast_w;
	wire [127:0] 	ep_cq_to_rp_rq_fifo_dout_tdata_w;
	wire [3:0] 	ep_cq_to_rp_rq_fifo_dout_tkeep_w;
	wire [84:0]	ep_cq_to_rp_rq_fifo_dout_tuser_w;

assign ep_cq_to_rp_rq_fifo_dout_tvalid_w = (ep_cq_to_rp_rq_fifo_valid) ? ep_cq_to_rp_rq_fifo_dout[218]    : 0;
assign ep_cq_to_rp_rq_fifo_dout_tlast_w  = (ep_cq_to_rp_rq_fifo_valid) ? ep_cq_to_rp_rq_fifo_dout[217]    : 0;
assign ep_cq_to_rp_rq_fifo_dout_tdata_w  = (ep_cq_to_rp_rq_fifo_valid) ? ep_cq_to_rp_rq_fifo_dout[216:89] : 0;
assign ep_cq_to_rp_rq_fifo_dout_tkeep_w  = (ep_cq_to_rp_rq_fifo_valid) ? ep_cq_to_rp_rq_fifo_dout[88:85]  : 0;
assign ep_cq_to_rp_rq_fifo_dout_tuser_w  = (ep_cq_to_rp_rq_fifo_valid) ? ep_cq_to_rp_rq_fifo_dout[84:0]   : 0;

/*
assign ep_cq_to_rp_rq_fifo_dout_tvalid_w = (ep_cq_to_rp_rq_fifo_rd_en) ? ep_cq_to_rp_rq_fifo_dout[218]    : 0;
assign ep_cq_to_rp_rq_fifo_dout_tlast_w  = (ep_cq_to_rp_rq_fifo_rd_en) ? ep_cq_to_rp_rq_fifo_dout[217]    : 0;
assign ep_cq_to_rp_rq_fifo_dout_tdata_w  = (ep_cq_to_rp_rq_fifo_rd_en) ? ep_cq_to_rp_rq_fifo_dout[216:89] : 0;
assign ep_cq_to_rp_rq_fifo_dout_tkeep_w  = (ep_cq_to_rp_rq_fifo_rd_en) ? ep_cq_to_rp_rq_fifo_dout[88:85]  : 0;
assign ep_cq_to_rp_rq_fifo_dout_tuser_w  = (ep_cq_to_rp_rq_fifo_rd_en) ? ep_cq_to_rp_rq_fifo_dout[84:0]   : 0;
*/


assign rp_s_axis_rq_tvalid = ep_cq_to_rp_rq_fifo_valid & (ep_cq_to_rp_rq_fifo_rd_en_delay_cycle == 2'd0);
//assign rp_s_axis_rq_tvalid = ep_cq_to_rp_rq_fifo_dout_tvalid_w;
assign rp_s_axis_rq_tlast  = ep_cq_to_rp_rq_fifo_dout_tlast_w;

reg 	ep_cq_to_rp_rq_fifo_is_first_head;

  always @(posedge rp_user_clk) begin
    if(rp_user_reset) 
      ep_cq_to_rp_rq_fifo_is_first_head <= 1'b1;
    else if ((ep_cq_to_rp_rq_fifo_dout_tvalid_w == 1'b1) & (ep_cq_to_rp_rq_fifo_dout_tlast_w == 1'b1))
      ep_cq_to_rp_rq_fifo_is_first_head <= 1'b1;
    else if ((ep_cq_to_rp_rq_fifo_dout_tvalid_w == 1'b1) & (ep_cq_to_rp_rq_fifo_dout_tlast_w == 1'b0))
      ep_cq_to_rp_rq_fifo_is_first_head <= 1'b0;
    else if ((ep_cq_to_rp_rq_fifo_dout_tvalid_w == 1'b0) & (ep_cq_to_rp_rq_fifo_dout_tlast_w == 1'b1))
      ep_cq_to_rp_rq_fifo_is_first_head <= 1'b1;
    else 	
      ep_cq_to_rp_rq_fifo_is_first_head <= ep_cq_to_rp_rq_fifo_is_first_head;
  end

always @(posedge rp_user_clk) begin
    if(rp_user_reset) 
        ep_cq_to_rp_rq_fifo_rd_en_delay_cycle <= 2'd2;
        
    else if ((ep_cq_to_rp_rq_fifo_valid == 1'b1) & (ep_cq_to_rp_rq_fifo_dout[217] == 1'b1) & (ep_cq_to_rp_rq_fifo_rd_en_delay_cycle == 2'd2))
        ep_cq_to_rp_rq_fifo_rd_en_delay_cycle <= 2'd0;
        
    else if ((ep_cq_to_rp_rq_fifo_valid == 1'b1) & (ep_cq_to_rp_rq_fifo_dout[217] == 1'b1) & (ep_cq_to_rp_rq_fifo_rd_en_delay_cycle == 2'd1))
        ep_cq_to_rp_rq_fifo_rd_en_delay_cycle <= 2'd0;
        
    else if ((ep_cq_to_rp_rq_fifo_valid == 1'b1) & (ep_cq_to_rp_rq_fifo_dout[217] == 1'b1) & (ep_cq_to_rp_rq_fifo_rd_en_delay_cycle == 2'd0))
        ep_cq_to_rp_rq_fifo_rd_en_delay_cycle <= 2'd1;
        
    else if ((ep_cq_to_rp_rq_fifo_valid == 1'b1) & (ep_cq_to_rp_rq_fifo_dout[217] == 1'b0) & (ep_cq_to_rp_rq_fifo_rd_en_delay_cycle != 2'd0))
        ep_cq_to_rp_rq_fifo_rd_en_delay_cycle <= ep_cq_to_rp_rq_fifo_rd_en_delay_cycle - 1; 
             
    else if (ep_cq_to_rp_rq_fifo_valid == 1'b0)       
        ep_cq_to_rp_rq_fifo_rd_en_delay_cycle <= 2'd2;
        
    else
        ep_cq_to_rp_rq_fifo_rd_en_delay_cycle <= ep_cq_to_rp_rq_fifo_rd_en_delay_cycle;
        
  end 
  
       
                                                                                                                  //[120]           [119:104]             [103:0]
								                                                                           //Requester ID Enable   CompleterID									
assign rp_s_axis_rq_tdata  = ep_cq_to_rp_rq_fifo_is_first_head ? {ep_cq_to_rp_rq_fifo_dout_tdata_w[127:121],         1'b1,        BUSNUMBER, 8'h00,  ep_cq_to_rp_rq_fifo_dout_tdata_w[103:0]} : ep_cq_to_rp_rq_fifo_dout_tdata_w[127:0];
assign rp_s_axis_rq_tkeep  = ep_cq_to_rp_rq_fifo_dout_tkeep_w;
 

// cq_tuser[3:0]   --> first_be[3:0]              // rq_tuser[3:0]   --> first_be[3:0]      
// cq_tuser[7:4]   --> last_be[3:0]               // rq_tuser[7:4]   --> last_be[3:0]       
// cq_tuser[39:8]  --> byte_en[31:0]              // rq_tuser[10:8]  --> addr_offset[2:0]   
// cq_tuser[40]    --> sop                        // rq_tuser[11]    --> discontinue        
// cq_tuser[41]    --> discontinue	    --->	  // rq_tuser[12]    --> tph_present        
// cq_tuser[42]    --> tph_present		          // rq_tuser[14:13] --> tph_type[1:0]			
// cq_tuser[44:43] --> tph_type[1:0]		      // rq_tuser[15]    --> tph_indirect_tag_en
// cq_tuser[52:45] --> tph_st_tag[7:0]            // rq_tuser[23:16] --> tph_st_tag[7:0]    
// cq_tuser[84:53] --> parity[31:0]		          // rq_tuser[27:24] --> seq_num[3:0]       
// cq_tuser[87:85] --> Reserved[2:0]              // rq_tuser[59:28] --> parity[31:0]       
                                                  // rq_tuser[61:60] --> seq_num[5:4]  
assign rp_s_axis_rq_tuser[3:0]   = ep_cq_to_rp_rq_fifo_dout_tuser_w[3:0];
assign rp_s_axis_rq_tuser[7:4]   = ep_cq_to_rp_rq_fifo_dout_tuser_w[7:4];
assign rp_s_axis_rq_tuser[10:8]  = 3'b0;
assign rp_s_axis_rq_tuser[11]    = ep_cq_to_rp_rq_fifo_dout_tuser_w[41];
assign rp_s_axis_rq_tuser[12]    = ep_cq_to_rp_rq_fifo_dout_tuser_w[42];
assign rp_s_axis_rq_tuser[14:13] = ep_cq_to_rp_rq_fifo_dout_tuser_w[44:43];
assign rp_s_axis_rq_tuser[15]    = 1'b0;
assign rp_s_axis_rq_tuser[23:16] = ep_cq_to_rp_rq_fifo_dout_tuser_w[52:45];
assign rp_s_axis_rq_tuser[27:24] = 3'b0;
assign rp_s_axis_rq_tuser[59:28] = 32'b0; //IP core disable parity check
//assign rp_s_axis_rq_tuser[61:60] = 3'b0;  //2022.11.01 jzhang

//----------------------------------------------------------------------------------------------------------------//
//  rp_rc_to_ep_cc_fifo                tvalid   tlast    tdata      tkeep     rc_tuser                              //
//                                        1  +    1    +   128    +   4     +   75    =   209                     //
//                                      [208]   [207]   [206:79]   [78:75]     [74:0]                              //
//----------------------------------------------------------------------------------------------------------------//
	wire         							rp_rc_to_ep_cc_fifo_rst;
	wire         							rp_rc_to_ep_cc_fifo_wr_clk;
	wire         							rp_rc_to_ep_cc_fifo_wr_en;
	wire 	[208:0] 						rp_rc_to_ep_cc_fifo_din;   //1  +    1    +   128    +   4     +   75    =   209
	wire         							rp_rc_to_ep_cc_fifo_full;
	wire         							rp_rc_to_ep_cc_fifo_prog_full;


	wire         							rp_rc_to_ep_cc_fifo_rd_clk;
	wire         							rp_rc_to_ep_cc_fifo_rd_en;
	wire         							rp_rc_to_ep_cc_fifo_valid;
	wire 	[208:0] 						rp_rc_to_ep_cc_fifo_dout;  //1  +    1    +   128    +   4     +   75    =   209
	wire         							rp_rc_to_ep_cc_fifo_empty;

rp_rc_to_ep_cc_fifo rp_rc_to_ep_cc_fifo_i (
	.rst       							(rp_rc_to_ep_cc_fifo_rst),
	.wr_clk    							(rp_rc_to_ep_cc_fifo_wr_clk),
	.wr_en     							(rp_rc_to_ep_cc_fifo_wr_en),
	.din       							(rp_rc_to_ep_cc_fifo_din),  // 1  +    1    +   128    +   4     +   75    =   209      
	.full      							(rp_rc_to_ep_cc_fifo_full),
	.prog_full 							(rp_rc_to_ep_cc_fifo_prog_full),
	.wr_rst_busy 							(),

	.rd_clk   							(rp_rc_to_ep_cc_fifo_rd_clk),
	.rd_en    							(rp_rc_to_ep_cc_fifo_rd_en),
	.valid    							(rp_rc_to_ep_cc_fifo_valid),
	.dout     							(rp_rc_to_ep_cc_fifo_dout),  // 1  +    1    +   128    +   4     +   75    =   209
	.empty    							(rp_rc_to_ep_cc_fifo_empty),
	.rd_rst_busy 							()
);

assign rp_rc_to_ep_cc_fifo_rst    = rp_user_reset;
assign rp_rc_to_ep_cc_fifo_wr_clk = rp_user_clk;
assign rp_rc_to_ep_cc_fifo_wr_en  = rp_m_axis_rc_tvalid & rp_m_axis_rc_tready;
assign rp_rc_to_ep_cc_fifo_din    = {rp_m_axis_rc_tvalid, rp_m_axis_rc_tlast, rp_m_axis_rc_tdata, rp_m_axis_rc_tkeep, rp_m_axis_rc_tuser};
assign rp_m_axis_rc_tready        = ~rp_rc_to_ep_cc_fifo_prog_full;


reg [1:0] rp_rc_to_ep_cc_fifo_rd_en_delay_cycle;

assign rp_rc_to_ep_cc_fifo_rd_clk = ep_user_clk;
assign rp_rc_to_ep_cc_fifo_rd_en  = ep_s_axis_cc_tready & (rp_rc_to_ep_cc_fifo_rd_en_delay_cycle == 2'd0);

	wire 		rp_rc_to_ep_cc_fifo_dout_tvalid_w;
	wire 		rp_rc_to_ep_cc_fifo_dout_tlast_w;
	wire [127:0] 	rp_rc_to_ep_cc_fifo_dout_tdata_w;
	wire [3:0] 	rp_rc_to_ep_cc_fifo_dout_tkeep_w;
	wire [74:0]	rp_rc_to_ep_cc_fifo_dout_tuser_w;

assign rp_rc_to_ep_cc_fifo_dout_tvalid_w = (rp_rc_to_ep_cc_fifo_valid) ? rp_rc_to_ep_cc_fifo_dout[208]    : 0;
assign rp_rc_to_ep_cc_fifo_dout_tlast_w  = (rp_rc_to_ep_cc_fifo_valid) ? rp_rc_to_ep_cc_fifo_dout[207]    : 0;
assign rp_rc_to_ep_cc_fifo_dout_tdata_w  = (rp_rc_to_ep_cc_fifo_valid) ? rp_rc_to_ep_cc_fifo_dout[206:79] : 0;
assign rp_rc_to_ep_cc_fifo_dout_tkeep_w  = (rp_rc_to_ep_cc_fifo_valid) ? rp_rc_to_ep_cc_fifo_dout[78:75]  : 0;
assign rp_rc_to_ep_cc_fifo_dout_tuser_w  = (rp_rc_to_ep_cc_fifo_valid) ? rp_rc_to_ep_cc_fifo_dout[74:0]   : 0;


assign ep_s_axis_cc_tvalid = rp_rc_to_ep_cc_fifo_valid & (rp_rc_to_ep_cc_fifo_rd_en_delay_cycle == 2'd0);
assign ep_s_axis_cc_tlast  = rp_rc_to_ep_cc_fifo_dout_tlast_w;

reg 	rp_rc_to_ep_cc_fifo_is_first_head;

  always @(posedge ep_user_clk) begin
    if(ep_user_reset) 
      rp_rc_to_ep_cc_fifo_is_first_head <= 1'b1;
    else if ((rp_rc_to_ep_cc_fifo_dout_tvalid_w == 1'b1) & (rp_rc_to_ep_cc_fifo_dout_tlast_w == 1'b1))
      rp_rc_to_ep_cc_fifo_is_first_head <= 1'b1;
    else if ((rp_rc_to_ep_cc_fifo_dout_tvalid_w == 1'b1) & (rp_rc_to_ep_cc_fifo_dout_tlast_w == 1'b0))
      rp_rc_to_ep_cc_fifo_is_first_head <= 1'b0;
    else if ((rp_rc_to_ep_cc_fifo_dout_tvalid_w == 1'b0) & (rp_rc_to_ep_cc_fifo_dout_tlast_w == 1'b1))
      rp_rc_to_ep_cc_fifo_is_first_head <= 1'b1;
    else 	
      rp_rc_to_ep_cc_fifo_is_first_head <= rp_rc_to_ep_cc_fifo_is_first_head;
  end
  
  
  always @(posedge ep_user_clk) begin
      if(ep_user_reset) 
          rp_rc_to_ep_cc_fifo_rd_en_delay_cycle <= 2'd2;
          
      else if ((rp_rc_to_ep_cc_fifo_valid == 1'b1) & (rp_rc_to_ep_cc_fifo_dout[207] == 1'b1) & (rp_rc_to_ep_cc_fifo_rd_en_delay_cycle == 2'd2))
          rp_rc_to_ep_cc_fifo_rd_en_delay_cycle <= 2'd0;
          
      else if ((rp_rc_to_ep_cc_fifo_valid == 1'b1) & (rp_rc_to_ep_cc_fifo_dout[207] == 1'b1) & (rp_rc_to_ep_cc_fifo_rd_en_delay_cycle == 2'd1))
          rp_rc_to_ep_cc_fifo_rd_en_delay_cycle <= 2'd0;
          
      else if ((rp_rc_to_ep_cc_fifo_valid == 1'b1) & (rp_rc_to_ep_cc_fifo_dout[207] == 1'b1) & (rp_rc_to_ep_cc_fifo_rd_en_delay_cycle == 2'd0))
          rp_rc_to_ep_cc_fifo_rd_en_delay_cycle <= 2'd1;
          
      else if ((rp_rc_to_ep_cc_fifo_valid == 1'b1) & (rp_rc_to_ep_cc_fifo_dout[207] == 1'b0) & (rp_rc_to_ep_cc_fifo_rd_en_delay_cycle != 2'd0))
          rp_rc_to_ep_cc_fifo_rd_en_delay_cycle <= rp_rc_to_ep_cc_fifo_rd_en_delay_cycle - 1; 
               
      else if (rp_rc_to_ep_cc_fifo_valid == 1'b0)       
          rp_rc_to_ep_cc_fifo_rd_en_delay_cycle <= 2'd2;
          
      else
          rp_rc_to_ep_cc_fifo_rd_en_delay_cycle <= rp_rc_to_ep_cc_fifo_rd_en_delay_cycle;
          
    end 
  
  
                                                                       //[88] --> Completer ID Enable
assign ep_s_axis_cc_tdata  = rp_rc_to_ep_cc_fifo_is_first_head ? {rp_rc_to_ep_cc_fifo_dout_tdata_w[127:89], 1'b1, rp_rc_to_ep_cc_fifo_dout_tdata_w[87:0]} :
								  rp_rc_to_ep_cc_fifo_dout_tdata_w[127:0];
assign ep_s_axis_cc_tkeep  = rp_rc_to_ep_cc_fifo_dout_tkeep_w;

// cc_tuser[0]      --> discontiue              // rc_tuser[31:0]  --> byte_en[31:0]      
// cc_tuser[32:1]    --> parity[31:0]           // rc_tuser[32]    --> is_sop_0   
                                                // rc_tuser[33]    --> is_sop_1  
//                                       <--    // rc_tuser[37:34] --> is_eop_0[3:0]           
                                                // rc_tuser[41:38] --> is_eop_1[3:0]		
                                                // rc_tuser[42]    --> discontiue		
                                                // rc_tuser[74:43] --> parity[31:0]
                               
assign ep_s_axis_cc_tuser[0]     = rp_rc_to_ep_cc_fifo_dout_tuser_w[42];
assign ep_s_axis_cc_tuser[32:1]  = rp_rc_to_ep_cc_fifo_dout_tuser_w[74:43];




reg	rp_RC_err;

  always @(posedge ep_user_clk) begin
    if(ep_user_reset) 
      rp_RC_err <= 1'd0;                                                                   
    else if (rp_rc_to_ep_cc_fifo_is_first_head & (rp_rc_to_ep_cc_fifo_dout_tvalid_w == 1'b1) & (rp_rc_to_ep_cc_fifo_dout_tdata_w[15:12] != 4'b0000))
      rp_RC_err <= 1'd1;
    else 	
      rp_RC_err <= rp_RC_err;
  end

//----------------------------------------------------------------------------------------------------------------//
//  rp_cq_to_ep_rq_fifo                tvalid   tlast    tdata      tkeep     cq_tuser                              //
//                                        1  +   1    +   128    +    4     +   85    =   219                     //
//                                      [218]   [217]   [216:89]   [88:85]    [84:0]                              //
//----------------------------------------------------------------------------------------------------------------//
	wire         							rp_cq_to_ep_rq_fifo_rst;
	wire         							rp_cq_to_ep_rq_fifo_wr_clk;
	wire         							rp_cq_to_ep_rq_fifo_wr_en;
	wire 	[218:0] 						rp_cq_to_ep_rq_fifo_din;   // 1  +   1    +  128  +   4   +  85  = 219
	wire         							rp_cq_to_ep_rq_fifo_full;
	wire         							rp_cq_to_ep_rq_fifo_prog_full;


	wire         							rp_cq_to_ep_rq_fifo_rd_clk;
	wire         							rp_cq_to_ep_rq_fifo_rd_en;
	wire         							rp_cq_to_ep_rq_fifo_valid;
	wire 	[218:0] 						rp_cq_to_ep_rq_fifo_dout;  // 1  +   1    +  128  +   4   +  85  = 219
	wire         							rp_cq_to_ep_rq_fifo_empty;

rp_cq_to_ep_rq_fifo rp_cq_to_ep_rq_fifo_i (
	.rst       							(rp_cq_to_ep_rq_fifo_rst),
	.wr_clk    							(rp_cq_to_ep_rq_fifo_wr_clk),
	.wr_en     							(rp_cq_to_ep_rq_fifo_wr_en),
	.din       							(rp_cq_to_ep_rq_fifo_din),  // 1  +   1    +  128  +   4   +  85  = 219       
	.full      							(rp_cq_to_ep_rq_fifo_full),
	.prog_full 							(rp_cq_to_ep_rq_fifo_prog_full),
	.wr_rst_busy 							(),

	.rd_clk   							(rp_cq_to_ep_rq_fifo_rd_clk),
	.rd_en    							(rp_cq_to_ep_rq_fifo_rd_en),
	.valid    							(rp_cq_to_ep_rq_fifo_valid),
	.dout     							(rp_cq_to_ep_rq_fifo_dout),  // 1  +   1    +  128  +   4   +  85  = 219
	.empty    							(rp_cq_to_ep_rq_fifo_empty),
	.rd_rst_busy 							()
);

assign rp_cq_to_ep_rq_fifo_rst    = rp_user_reset;
assign rp_cq_to_ep_rq_fifo_wr_clk = rp_user_clk;
assign rp_cq_to_ep_rq_fifo_wr_en  = rp_m_axis_cq_tvalid & rp_m_axis_cq_tready;
assign rp_cq_to_ep_rq_fifo_din    = {rp_m_axis_cq_tvalid, rp_m_axis_cq_tlast, rp_m_axis_cq_tdata, rp_m_axis_cq_tkeep, rp_m_axis_cq_tuser};
assign rp_m_axis_cq_tready        = ~rp_cq_to_ep_rq_fifo_prog_full;


reg [1:0] rp_cq_to_ep_rq_fifo_rd_en_delay_cycle;

assign rp_cq_to_ep_rq_fifo_rd_clk = ep_user_clk;
assign rp_cq_to_ep_rq_fifo_rd_en  = ep_s_axis_rq_tready & (rp_cq_to_ep_rq_fifo_rd_en_delay_cycle == 2'd0);

	wire 		rp_cq_to_ep_rq_fifo_dout_tvalid_w;
	wire 		rp_cq_to_ep_rq_fifo_dout_tlast_w;
	wire [127:0] 	rp_cq_to_ep_rq_fifo_dout_tdata_w;
	wire [3:0] 	rp_cq_to_ep_rq_fifo_dout_tkeep_w;
	wire [84:0]	rp_cq_to_ep_rq_fifo_dout_tuser_w;

assign rp_cq_to_ep_rq_fifo_dout_tvalid_w = (rp_cq_to_ep_rq_fifo_valid) ? rp_cq_to_ep_rq_fifo_dout[218]    : 0;
assign rp_cq_to_ep_rq_fifo_dout_tlast_w  = (rp_cq_to_ep_rq_fifo_valid) ? rp_cq_to_ep_rq_fifo_dout[217]    : 0;
assign rp_cq_to_ep_rq_fifo_dout_tdata_w  = (rp_cq_to_ep_rq_fifo_valid) ? rp_cq_to_ep_rq_fifo_dout[216:89] : 0;
assign rp_cq_to_ep_rq_fifo_dout_tkeep_w  = (rp_cq_to_ep_rq_fifo_valid) ? rp_cq_to_ep_rq_fifo_dout[88:85]  : 0;
assign rp_cq_to_ep_rq_fifo_dout_tuser_w  = (rp_cq_to_ep_rq_fifo_valid) ? rp_cq_to_ep_rq_fifo_dout[84:0]   : 0;


assign ep_s_axis_rq_tvalid = rp_cq_to_ep_rq_fifo_valid & (rp_cq_to_ep_rq_fifo_rd_en_delay_cycle == 2'd0);
assign ep_s_axis_rq_tlast  = rp_cq_to_ep_rq_fifo_dout_tlast_w;

 reg 	rp_cq_to_ep_rq_fifo_is_first_head;       
  
 always @(posedge ep_user_clk) begin
    if(ep_user_reset) 
      rp_cq_to_ep_rq_fifo_is_first_head <= 1'b1;
    else if ((rp_cq_to_ep_rq_fifo_dout_tvalid_w == 1'b1) & (rp_cq_to_ep_rq_fifo_dout_tlast_w == 1'b1))
      rp_cq_to_ep_rq_fifo_is_first_head <= 1'b1;
    else if ((rp_cq_to_ep_rq_fifo_dout_tvalid_w == 1'b1) & (rp_cq_to_ep_rq_fifo_dout_tlast_w == 1'b0))
      rp_cq_to_ep_rq_fifo_is_first_head <= 1'b0;
    else if ((rp_cq_to_ep_rq_fifo_dout_tvalid_w == 1'b0) & (rp_cq_to_ep_rq_fifo_dout_tlast_w == 1'b1))
      rp_cq_to_ep_rq_fifo_is_first_head <= 1'b1;
    else     
      rp_cq_to_ep_rq_fifo_is_first_head <= rp_cq_to_ep_rq_fifo_is_first_head;
  end        
  
always @(posedge ep_user_clk) begin
    if(ep_user_reset) 
        rp_cq_to_ep_rq_fifo_rd_en_delay_cycle <= 2'd2;
        
    else if ((rp_cq_to_ep_rq_fifo_valid == 1'b1) & (rp_cq_to_ep_rq_fifo_dout[217] == 1'b1) & (rp_cq_to_ep_rq_fifo_rd_en_delay_cycle == 2'd2))
        rp_cq_to_ep_rq_fifo_rd_en_delay_cycle <= 2'd0;
        
    else if ((rp_cq_to_ep_rq_fifo_valid == 1'b1) & (rp_cq_to_ep_rq_fifo_dout[217] == 1'b1) & (rp_cq_to_ep_rq_fifo_rd_en_delay_cycle == 2'd1))
        rp_cq_to_ep_rq_fifo_rd_en_delay_cycle <= 2'd0;
        
    else if ((rp_cq_to_ep_rq_fifo_valid == 1'b1) & (rp_cq_to_ep_rq_fifo_dout[217] == 1'b1) & (rp_cq_to_ep_rq_fifo_rd_en_delay_cycle == 2'd0))
        rp_cq_to_ep_rq_fifo_rd_en_delay_cycle <= 2'd1;
        
    else if ((rp_cq_to_ep_rq_fifo_valid == 1'b1) & (rp_cq_to_ep_rq_fifo_dout[217] == 1'b0) & (rp_cq_to_ep_rq_fifo_rd_en_delay_cycle != 2'd0))
        rp_cq_to_ep_rq_fifo_rd_en_delay_cycle <= rp_cq_to_ep_rq_fifo_rd_en_delay_cycle - 1; 
             
    else if (rp_cq_to_ep_rq_fifo_valid == 1'b0)       
        rp_cq_to_ep_rq_fifo_rd_en_delay_cycle <= 2'd2;
        
    else
        rp_cq_to_ep_rq_fifo_rd_en_delay_cycle <= rp_cq_to_ep_rq_fifo_rd_en_delay_cycle;
        
  end              
                 
                                                                                                           //[120]                  [119:104]             [103:0]
								                                                                           //Requester ID Enable   CompleterID			    //2022.04.15   
assign ep_s_axis_rq_tdata  = rp_cq_to_ep_rq_fifo_is_first_head ? {rp_cq_to_ep_rq_fifo_dout_tdata_w[127:121], 1'b1,                 8'h00, 8'h00,   rp_cq_to_ep_rq_fifo_dout_tdata_w[103:0]} : 
								  rp_cq_to_ep_rq_fifo_dout_tdata_w[127:0];
assign ep_s_axis_rq_tkeep  = rp_cq_to_ep_rq_fifo_dout_tkeep_w;
 

// cq_tuser[3:0]   --> first_be[3:0]              // rq_tuser[3:0]   --> first_be[3:0]      
// cq_tuser[7:4]   --> last_be[3:0]               // rq_tuser[7:4]   --> last_be[3:0]       
// cq_tuser[39:8]  --> byte_en[31:0]              // rq_tuser[10:8]  --> addr_offset[2:0]   
// cq_tuser[40]    --> sop                        // rq_tuser[11]    --> discontinue        
// cq_tuser[41]    --> discontinue	    --->	  // rq_tuser[12]    --> tph_present        
// cq_tuser[42]    --> tph_present		          // rq_tuser[14:13] --> tph_type[1:0]			
// cq_tuser[44:43] --> tph_type[1:0]		      // rq_tuser[15]    --> tph_indirect_tag_en
// cq_tuser[52:45] --> tph_st_tag[7:0]            // rq_tuser[23:16] --> tph_st_tag[7:0]    
// cq_tuser[84:53] --> parity[31:0]		          // rq_tuser[27:24] --> seq_num[3:0]       
// cq_tuser[87:85] --> Reserved[2:0]              // rq_tuser[59:28] --> parity[31:0]       
                                                  // rq_tuser[61:60] --> seq_num[5:4]  
assign ep_s_axis_rq_tuser[3:0]   = rp_cq_to_ep_rq_fifo_dout_tuser_w[3:0];
assign ep_s_axis_rq_tuser[7:4]   = rp_cq_to_ep_rq_fifo_dout_tuser_w[7:4];
assign ep_s_axis_rq_tuser[10:8]  = 3'b0;
assign ep_s_axis_rq_tuser[11]    = rp_cq_to_ep_rq_fifo_dout_tuser_w[41];
assign ep_s_axis_rq_tuser[12]    = rp_cq_to_ep_rq_fifo_dout_tuser_w[42];
assign ep_s_axis_rq_tuser[14:13] = rp_cq_to_ep_rq_fifo_dout_tuser_w[44:43];
assign ep_s_axis_rq_tuser[15]    = 1'b0;
assign ep_s_axis_rq_tuser[23:16] = rp_cq_to_ep_rq_fifo_dout_tuser_w[52:45];
assign ep_s_axis_rq_tuser[27:24] = 4'b0;
assign ep_s_axis_rq_tuser[59:28] = 32'b0; //IP core disable parity check
//assign ep_s_axis_rq_tuser[61:60] = 3'b0;  //2022.11.01 jzhang

//----------------------------------------------------------------------------------------------------------------//
//  ep_rc_to_rp_cc_fifo                tvalid   tlast    tdata      tkeep     rc_tuser                              //
//                                        1  +    1    +   128    +   4     +   75    =   209                     //
//                                      [208]   [207]   [206:79]   [78:75]     [74:0]                              //
//----------------------------------------------------------------------------------------------------------------//
	wire         							ep_rc_to_rp_cc_fifo_rst;
	wire         							ep_rc_to_rp_cc_fifo_wr_clk;
	wire         							ep_rc_to_rp_cc_fifo_wr_en;
	wire 	[208:0] 						ep_rc_to_rp_cc_fifo_din;   //1  +    1    +   128    +   4     +   75    =   209
	wire         							ep_rc_to_rp_cc_fifo_full;
	wire         							ep_rc_to_rp_cc_fifo_prog_full;


	wire         							ep_rc_to_rp_cc_fifo_rd_clk;
	wire         							ep_rc_to_rp_cc_fifo_rd_en;
	wire         							ep_rc_to_rp_cc_fifo_valid;
	wire 	[208:0] 						ep_rc_to_rp_cc_fifo_dout;  //1  +    1    +   128    +   4     +   75    =   209
	wire         							ep_rc_to_rp_cc_fifo_empty;

ep_rc_to_rp_cc_fifo ep_rc_to_rp_cc_fifo_i (
	.rst       							(ep_rc_to_rp_cc_fifo_rst),
	.wr_clk    							(ep_rc_to_rp_cc_fifo_wr_clk),
	.wr_en     							(ep_rc_to_rp_cc_fifo_wr_en),
	.din       							(ep_rc_to_rp_cc_fifo_din),  // 1  +    1    +   128    +   4     +   75    =   209      
	.full      							(ep_rc_to_rp_cc_fifo_full),
	.prog_full 							(ep_rc_to_rp_cc_fifo_prog_full),
	.wr_rst_busy 							(),

	.rd_clk   							(ep_rc_to_rp_cc_fifo_rd_clk),
	.rd_en    							(ep_rc_to_rp_cc_fifo_rd_en),
	.valid    							(ep_rc_to_rp_cc_fifo_valid),
	.dout     							(ep_rc_to_rp_cc_fifo_dout),  // 1  +    1    +   128    +   4     +   75    =   209
	.empty    							(ep_rc_to_rp_cc_fifo_empty),
	.rd_rst_busy 							()
);

assign ep_rc_to_rp_cc_fifo_rst    = ep_user_reset;
assign ep_rc_to_rp_cc_fifo_wr_clk = ep_user_clk;
assign ep_rc_to_rp_cc_fifo_wr_en  = ep_m_axis_rc_tvalid & ep_m_axis_rc_tready;
assign ep_rc_to_rp_cc_fifo_din    = {ep_m_axis_rc_tvalid, ep_m_axis_rc_tlast, ep_m_axis_rc_tdata, ep_m_axis_rc_tkeep, ep_m_axis_rc_tuser};
assign ep_m_axis_rc_tready        = ~ep_rc_to_rp_cc_fifo_prog_full;


reg [1:0] ep_rc_to_rp_cc_fifo_rd_en_delay_cycle;

assign ep_rc_to_rp_cc_fifo_rd_clk = rp_user_clk;
assign ep_rc_to_rp_cc_fifo_rd_en  = rp_s_axis_cc_tready  & (ep_rc_to_rp_cc_fifo_rd_en_delay_cycle == 2'd0);

	wire 		ep_rc_to_rp_cc_fifo_dout_tvalid_w;
	wire 		ep_rc_to_rp_cc_fifo_dout_tlast_w;
	wire [127:0] 	ep_rc_to_rp_cc_fifo_dout_tdata_w;
	wire [3:0] 	ep_rc_to_rp_cc_fifo_dout_tkeep_w;
	wire [74:0]	ep_rc_to_rp_cc_fifo_dout_tuser_w;

assign ep_rc_to_rp_cc_fifo_dout_tvalid_w = (ep_rc_to_rp_cc_fifo_valid) ? ep_rc_to_rp_cc_fifo_dout[208]    : 0;
assign ep_rc_to_rp_cc_fifo_dout_tlast_w  = (ep_rc_to_rp_cc_fifo_valid) ? ep_rc_to_rp_cc_fifo_dout[207]    : 0;
assign ep_rc_to_rp_cc_fifo_dout_tdata_w  = (ep_rc_to_rp_cc_fifo_valid) ? ep_rc_to_rp_cc_fifo_dout[206:79] : 0;
assign ep_rc_to_rp_cc_fifo_dout_tkeep_w  = (ep_rc_to_rp_cc_fifo_valid) ? ep_rc_to_rp_cc_fifo_dout[78:75]  : 0;
assign ep_rc_to_rp_cc_fifo_dout_tuser_w  = (ep_rc_to_rp_cc_fifo_valid) ? ep_rc_to_rp_cc_fifo_dout[74:0]   : 0;


assign rp_s_axis_cc_tvalid = ep_rc_to_rp_cc_fifo_valid & (ep_rc_to_rp_cc_fifo_rd_en_delay_cycle == 2'd0);
assign rp_s_axis_cc_tlast  = ep_rc_to_rp_cc_fifo_dout_tlast_w;

 reg 	ep_rc_to_rp_cc_fifo_is_first_head;

  always @(posedge rp_user_clk) begin
    if(rp_user_reset) 
      ep_rc_to_rp_cc_fifo_is_first_head <= 1'b1;
    else if ((ep_rc_to_rp_cc_fifo_dout_tvalid_w == 1'b1) & (ep_rc_to_rp_cc_fifo_dout_tlast_w == 1'b1))
      ep_rc_to_rp_cc_fifo_is_first_head <= 1'b1;
    else if ((ep_rc_to_rp_cc_fifo_dout_tvalid_w == 1'b1) & (ep_rc_to_rp_cc_fifo_dout_tlast_w == 1'b0))
      ep_rc_to_rp_cc_fifo_is_first_head <= 1'b0;
    else if ((ep_rc_to_rp_cc_fifo_dout_tvalid_w == 1'b0) & (ep_rc_to_rp_cc_fifo_dout_tlast_w == 1'b1))
      ep_rc_to_rp_cc_fifo_is_first_head <= 1'b1;
    else 	
      ep_rc_to_rp_cc_fifo_is_first_head <= ep_rc_to_rp_cc_fifo_is_first_head;
  end    
      
      
always @(posedge rp_user_clk) begin
      if(rp_user_reset) 
          ep_rc_to_rp_cc_fifo_rd_en_delay_cycle <= 2'd2;
          
      else if ((ep_rc_to_rp_cc_fifo_valid == 1'b1) & (ep_rc_to_rp_cc_fifo_dout[207] == 1'b1) & (ep_rc_to_rp_cc_fifo_rd_en_delay_cycle == 2'd2))
          ep_rc_to_rp_cc_fifo_rd_en_delay_cycle <= 2'd0;
          
      else if ((ep_rc_to_rp_cc_fifo_valid == 1'b1) & (ep_rc_to_rp_cc_fifo_dout[207] == 1'b1) & (ep_rc_to_rp_cc_fifo_rd_en_delay_cycle == 2'd1))
          ep_rc_to_rp_cc_fifo_rd_en_delay_cycle <= 2'd0;
          
      else if ((ep_rc_to_rp_cc_fifo_valid == 1'b1) & (ep_rc_to_rp_cc_fifo_dout[207] == 1'b1) & (ep_rc_to_rp_cc_fifo_rd_en_delay_cycle == 2'd0))
          ep_rc_to_rp_cc_fifo_rd_en_delay_cycle <= 2'd1;
          
      else if ((ep_rc_to_rp_cc_fifo_valid == 1'b1) & (ep_rc_to_rp_cc_fifo_dout[207] == 1'b0) & (ep_rc_to_rp_cc_fifo_rd_en_delay_cycle != 2'd0))
          ep_rc_to_rp_cc_fifo_rd_en_delay_cycle <= ep_rc_to_rp_cc_fifo_rd_en_delay_cycle - 1; 
               
      else if (ep_rc_to_rp_cc_fifo_valid == 1'b0)       
          ep_rc_to_rp_cc_fifo_rd_en_delay_cycle <= 2'd2;
          
      else
          ep_rc_to_rp_cc_fifo_rd_en_delay_cycle <= ep_rc_to_rp_cc_fifo_rd_en_delay_cycle;
          
    end       
      
      
                                                                                                           //[88] --> Completer ID Enable
assign rp_s_axis_cc_tdata  = ep_rc_to_rp_cc_fifo_is_first_head ? {ep_rc_to_rp_cc_fifo_dout_tdata_w[127:89], 1'b1, ep_rc_to_rp_cc_fifo_dout_tdata_w[87:0]} : 
								  ep_rc_to_rp_cc_fifo_dout_tdata_w[127:0];
assign rp_s_axis_cc_tkeep  = ep_rc_to_rp_cc_fifo_dout_tkeep_w;

// cc_tuser[0]      --> discontiue              // rc_tuser[31:0]  --> byte_en[31:0]      
// cc_tuser[32:1]    --> parity[31:0]           // rc_tuser[32]    --> is_sop_0   
                                                // rc_tuser[33]    --> is_sop_1  
//                                       <--    // rc_tuser[37:34] --> is_eop_0[3:0]           
                                                // rc_tuser[41:38] --> is_eop_1[3:0]		
                                                // rc_tuser[42]    --> discontiue		
                                                // rc_tuser[74:43] --> parity[31:0]
                               
assign rp_s_axis_cc_tuser[0]     = ep_rc_to_rp_cc_fifo_dout_tuser_w[42];
assign rp_s_axis_cc_tuser[32:1]  = ep_rc_to_rp_cc_fifo_dout_tuser_w[74:43];


reg	ep_RC_err;

  always @(posedge rp_user_clk) begin
    if(rp_user_reset) 
      ep_RC_err <= 1'd0;                                                                   
    else if (ep_rc_to_rp_cc_fifo_is_first_head & (ep_rc_to_rp_cc_fifo_dout_tvalid_w == 1'b1) & (ep_rc_to_rp_cc_fifo_dout_tdata_w[15:12] != 4'b0000))
      ep_RC_err <= 1'd1;
    else 	
      ep_RC_err <= ep_RC_err;
  end
  
  
reg  [31:0]  ep_lnk_cout,rc_lnk_cout;

always@(posedge ep_user_clk )begin
    if(ep_user_reset)
        ep_lnk_cout <= 32'd0;
    else if(ep_user_lnk_up & (ep_lnk_cout == 'd62500000))
        ep_lnk_cout <= 32'd0;
    else
        ep_lnk_cout <= ep_lnk_cout + 1;
  end
  
  always@(posedge rp_user_clk )begin
    if(rp_user_reset)
        rc_lnk_cout <= 32'd0;
    else if(rp_user_lnk_up & (rc_lnk_cout == 'd62500000))
        rc_lnk_cout <= 32'd0;
    else
        rc_lnk_cout <= rc_lnk_cout + 1;
  end
  
  always@(posedge ep_user_clk )begin
    if(ep_user_reset)begin
        led[0] <= 1'b0;
     end
    else if(ep_lnk_cout == 'd62500000)
        led[0] <= ~led[0];
    else
        led[0] <= led[0];
  end  
  
  always@(posedge rp_user_clk )begin
    if(rp_user_reset)
        led[1] <= 1'b0;
    else if(rc_lnk_cout == 'd62500000)
        led[1] <= ~led[1];
    else
        led[1] <= led[1];
  end  
 /* 
 generate
 
  if(DNA_EN == 1'b1)
  
    dna_top #(
  
      .DNA_ID   (DNA_ID),
      .DNA_BIT_CNT(DNA_BIT_CNT)
  
   ) dna_top_i(
  
      .clk  (clk100),
      .rst  (~ep_sys_rst_n),
      .flag (dna_ok_flag)
 
  );
 endgenerate
*/
  /*  
  
top_ep_ila top_ep_ila_i (
      .clk(ep_user_clk),
      
      .probe0(ep_m_axis_cq_tready),  // 1
      .probe1(ep_m_axis_cq_tvalid),  // 1
      .probe2(ep_m_axis_cq_tlast),   // 1
      .probe3(ep_m_axis_cq_tkeep),   // 4
      .probe4(ep_m_axis_cq_tdata),   // 128
      .probe5(ep_m_axis_cq_tuser),   // 85    +=  220
  
      .probe6(ep_s_axis_cc_tready),  // 1
      .probe7(ep_s_axis_cc_tvalid),  // 1
      .probe8(ep_s_axis_cc_tlast),   // 1
      .probe9(ep_s_axis_cc_tkeep),   // 4
      .probe10(ep_s_axis_cc_tdata),   // 128
      .probe11(ep_s_axis_cc_tuser),   // 33    +=  168
  
      .probe12(ep_s_axis_rq_tready),  // 1
      .probe13(ep_s_axis_rq_tvalid),  // 1
      .probe14(ep_s_axis_rq_tlast),   // 1
      .probe15(ep_s_axis_rq_tkeep),   // 4
      .probe16(ep_s_axis_rq_tdata),   // 128
      .probe17(ep_s_axis_rq_tuser),   // 60    +=  195
  
      .probe18(ep_m_axis_rc_tready),  // 1
      .probe19(ep_m_axis_rc_tvalid),  // 1
      .probe20(ep_m_axis_rc_tlast),   // 1
      .probe21(ep_m_axis_rc_tkeep),   // 4
      .probe22(ep_m_axis_rc_tdata),   // 128
      .probe23(ep_m_axis_rc_tuser)    // 75    +=  210
      
  
      );
 
 top_ep_ila top_rp_ila_i (
       
       .clk(rp_user_clk),
       
       .probe0 (rp_m_axis_cq_tready),  // 1
       .probe1 (rp_m_axis_cq_tvalid),  // 1
       .probe2 (rp_m_axis_cq_tlast),   // 1
       .probe3 (rp_m_axis_cq_tkeep),   // 4
       .probe4 (rp_m_axis_cq_tdata),   // 128
       .probe5 (rp_m_axis_cq_tuser),   // 85    +=  220
  
       .probe6 (rp_s_axis_cc_tready),  // 1
       .probe7 (rp_s_axis_cc_tvalid),  // 1
       .probe8 (rp_s_axis_cc_tlast),   // 1
       .probe9 (rp_s_axis_cc_tkeep),   // 4
       .probe10(rp_s_axis_cc_tdata),   // 128
       .probe11(rp_s_axis_cc_tuser),   // 33    +=  168
  
       .probe12(rp_s_axis_rq_tready),  // 1
       .probe13(rp_s_axis_rq_tvalid),  // 1
       .probe14(rp_s_axis_rq_tlast),   // 1
       .probe15(rp_s_axis_rq_tkeep),   // 4
       .probe16(rp_s_axis_rq_tdata),   // 128
       .probe17(rp_s_axis_rq_tuser),   // 60    +=  195
  
       .probe18(rp_m_axis_rc_tready),  // 1
       .probe19(rp_m_axis_rc_tvalid),  // 1
       .probe20(rp_m_axis_rc_tlast),   // 1
       .probe21(rp_m_axis_rc_tkeep),   // 4
       .probe22(rp_m_axis_rc_tdata),   // 128
       .probe23(rp_m_axis_rc_tuser)    // 75    +=  210
             
         
             );
*/
endmodule

