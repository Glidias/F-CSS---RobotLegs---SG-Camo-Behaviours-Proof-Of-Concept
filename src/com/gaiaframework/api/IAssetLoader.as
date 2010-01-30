package com.gaiaframework.api
{
	import com.gaiaframework.api.IAsset;
	
	/**
	 * Public interface for AssetLoader class, to allow users to make use of new AssetLoader instances.
	 * @author Glenn Ko
	 */
	public interface IAssetLoader 
	{
		function loadAssets(...args):void;
		function abortAll():void;
		function disposeAll():void;
		function destroy():void;
		function set preloaderInstance(val:IPreloader):void;
		
		function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void;
		function removeEventListener (type:String, listener:Function, useCapture:Boolean = false) : void;
	}
	
}