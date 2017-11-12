-- ==============================================================
-- File generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2015.2
-- Copyright (C) 2015 Xilinx Inc. All rights reserved.
-- 
-- ==============================================================


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity encode_mux_4to1_sel2_32_1 is
generic (
    ID            :integer := 0;
    NUM_STAGE     :integer := 1;
    din1_WIDTH       :integer := 32;
    din2_WIDTH       :integer := 32;
    din3_WIDTH       :integer := 32;
    din4_WIDTH       :integer := 32;
    din5_WIDTH       :integer := 32;
    dout_WIDTH        :integer := 32);
port (
    din1   :in  std_logic_vector(31 downto 0);
    din2   :in  std_logic_vector(31 downto 0);
    din3   :in  std_logic_vector(31 downto 0);
    din4   :in  std_logic_vector(31 downto 0);
    din5   :in  std_logic_vector(1 downto 0);
    dout     :out std_logic_vector(31 downto 0));
end entity;

architecture rtl of encode_mux_4to1_sel2_32_1 is
    -- puts internal signals
    signal sel    : std_logic_vector(1 downto 0);
    -- level 1 signals
    signal mux_1_0    : std_logic_vector(31 downto 0);
    signal mux_1_1    : std_logic_vector(31 downto 0);
    -- level 2 signals
    signal mux_2_0    : std_logic_vector(31 downto 0);
begin

sel <= din5;

-- Generate level 1 logic
mux_1_0 <= din1 when sel(0) = '0' else din2;
mux_1_1 <= din3 when sel(0) = '0' else din4;

-- Generate level 2 logic
mux_2_0 <= mux_1_0 when sel(1) = '0' else mux_1_1;

-- output logic
dout <= mux_2_0;

end architecture;
