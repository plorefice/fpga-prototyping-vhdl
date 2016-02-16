-- Common functions used in some modules

library ieee;
use ieee.std_logic_1164.all;

package common_p is
	function reverse (x : in std_logic_vector)
		return std_logic_vector;
end package ; -- common_p 

package body common_p is
	function reverse (x : in std_logic_vector)
			return std_logic_vector is
		variable result : std_logic_vector(x'reverse_range);
	begin
		rev_loop : for i in x'range loop
			result(i) := x(i);
		end loop ; -- rev_loop
		return result;
	end ; -- reverse
end common_p ;
