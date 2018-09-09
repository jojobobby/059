﻿//com.company.util.MoreStringUtil

package com.company.util
{
import flash.utils.ByteArray;

public class MoreStringUtil
{


	public static function hexStringToByteArray(_arg_1:String):ByteArray
	{
		var _local_2:ByteArray = new ByteArray();
		var _local_3:int;
		while (_local_3 < _arg_1.length)
		{
			_local_2.writeByte(parseInt(_arg_1.substr(_local_3, 2), 16));
			_local_3 = (_local_3 + 2);
		}
		return (_local_2);
	}

	public static function cmp(_arg_1:String, _arg_2:String):Number
	{
		return (_arg_1.localeCompare(_arg_2));
	}

	public static function countCharInString(_arg_1:String, _arg_2:String):int
	{
		var _local_4:uint;
		var _local_3:int;
		_local_4 = 0;
		while (_local_4 < _arg_1.length)
		{
			if (_arg_1.charAt(_local_4) == _arg_2)
			{
				_local_3++;
			}
			_local_4++;
		}
		return (_local_3);
	}


}
}//package com.company.util

