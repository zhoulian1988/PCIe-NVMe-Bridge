-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
-- Date        : Fri May 26 14:24:56 2023
-- Host        : 192.168.2.204 running 64-bit unknown
-- Command     : write_vhdl -force -mode synth_stub
--               /home/zhoulian/work/690t_bypass/jzhang/bypass/ips_690t/axis_data_fifo_ep_cq_rp_rq/axis_data_fifo_ep_cq_rp_rq_stub.vhdl
-- Design      : axis_data_fifo_ep_cq_rp_rq
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7vx690tffg1761-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity axis_data_fifo_ep_cq_rp_rq is
  Port ( 
    s_axis_aresetn : in STD_LOGIC;
    s_axis_aclk : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axis_tlast : in STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    m_axis_tlast : out STD_LOGIC;
    axis_data_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    axis_wr_data_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    axis_rd_data_count : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end axis_data_fifo_ep_cq_rp_rq;

architecture stub of axis_data_fifo_ep_cq_rp_rq is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "s_axis_aresetn,s_axis_aclk,s_axis_tvalid,s_axis_tready,s_axis_tdata[127:0],s_axis_tlast,m_axis_tvalid,m_axis_tready,m_axis_tdata[127:0],m_axis_tlast,axis_data_count[31:0],axis_wr_data_count[31:0],axis_rd_data_count[31:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "axis_data_fifo_v1_1_18_axis_data_fifo,Vivado 2018.2";
begin
end;
