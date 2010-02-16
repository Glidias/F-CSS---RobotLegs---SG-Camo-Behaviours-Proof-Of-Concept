/**  * <p>Original Author:  jessefreeman</p> * <p>Class File: CamoDisplay.as</p> *  * <p>Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions:</p> *  * <p>The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software.</p> *  * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE.</p> *  * <p>Licensed under The MIT License</p> * <p>Redistributions of files must retain the above copyright notice.</p> * * <p>Revisions<br/>  * 	2.0  Initial version Jan 7, 2009</p> *  *  *  *  Changes made on Sept 05, 2009 - Glenn (commented) *  *  * Removed validate vertical align/and align within class, since validation can be done * on behaviour level depending on the type of behaviour class being used. * */package camo.core.display {	import camo.core.enum.CSSProperties;	// Removed off PpropertyApplierUtil. CamoDIsplay no longer applies properties on himself.,		import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.DisplayObject;	import flash.display.Loader;	import flash.display.LoaderInfo;	import flash.display.Shape;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.net.URLRequest;	import flash.utils.Dictionary;	//import flash.utils.getQualifiedClassName;	 // -- no longer needed		/**	 * CamoDisplay is the base class which supports a fully skinnable/resizable container	 * with background image, rasterization support, overflow masking, etc. while also inheriting	 * from CSS's skinnable box model.	 * 	 * @author jessefreeman	 * 	 * @author glenn  (changes commented)	 */	public class CamoDisplay extends BoxModelDisplay implements ICamoDisplay	{		protected var maskShape : Shape;	//	protected var _className : String;    // reflections not really used in extended implementations		protected var _bgImageLoader : Loader;		protected var cachedBackgroundImages : Dictionary = new Dictionary( true );		protected var backgroundImageSource : String;		protected var _cursor : String;		protected var _verticalAlign : String;		protected var _align : String;		protected var _zIndex : Number;		protected var _rasterSmoothing:Boolean = false;  // added raster smoothing option			public function set verticalAlign(value : String) : void		{			_verticalAlign =value;		}				public function set rasterSmoothing(boo:Boolean):void {			_rasterSmoothing = boo;		}		public function get rasterSmoothing():Boolean {			return _rasterSmoothing;		}				public function get zIndex():Number {			return _zIndex;		}		public function set zIndex(val:Number):void {			_zIndex = val;		}			public function get verticalAlign() : String		{			return _verticalAlign;		}			public function set align(value : String) : void		{			_align =  value;		}			public function get align() : String		{			return _align;		}		public function set overflow(value : String) : void		{			switch (value)			{				case CSSProperties.HIDDEN: 					{					activateOverflowHidden();					break;				}				case CSSProperties.SCROLL:				{					activateOverflowHidden();					activateOverflowScroll();					break;				}				case CSSProperties.AUTO:				{					activateOverflowAuto();					break;				}				default:				{						clearOverflow();					break;				}				}		}					protected function activateOverflowHidden():void		{			if(maskShape)				maskShape.graphics.clear();			else				maskShape = new Shape();						if(_width == 0) _width = 1;			if(_height == 0) _height = 1;						maskShape.graphics.beginFill(0xff0000,1);			maskShape.graphics.drawRect(0,0,_width, _height);			maskShape.graphics.endFill();			$addChild(maskShape);			display.mask = maskShape;		}				public function set backgroundImage(value:URLRequest):void		{						if(value.url == "none")			{				clearBackground();			}			else			{				invalidate();				loadBackgroundImage(value);			}		}		protected function loadBackgroundImage(request:URLRequest):void		{						if(!cachedBackgroundImages[request.url])			{				_bgImageLoader = new Loader();								backgroundImageSource = request.url;								addListeners(_bgImageLoader.contentLoaderInfo);				_bgImageLoader.load(request);											}			else			{				sampleBackground(cachedBackgroundImages[request.url]);			}		}						// No scale 9 implementation ?		/**		 *  Jesse: <p>This is called when a BG Image is loaded. It attaches the BG Image's		 *	BitmapData to the _backgroundImageContainer. If 9 Slice data was 		 *	supplied it will put the BitmapData into a ScaleBitmap class, apply		 *	the 9 slice values to allow undistorted stretching of the supplied		 *	BG Image.</p>		 */		protected function onBGImageLoad(e : Event) : void 		{			var info : LoaderInfo = e.target as LoaderInfo;			var loader : Loader = info.loader;			//var source:String = e.target.url;						var tempBitmap : Bitmap = Bitmap(loader.content);						if(backgroundImageSource)				cachedBackgroundImages[backgroundImageSource] = tempBitmap;						if( _bgImageLoader )				if( _bgImageLoader.contentLoaderInfo )					removeListeners(_bgImageLoader.contentLoaderInfo);						sampleBackground(tempBitmap);						// bubble event once			dispatchEvent(e);		}					override protected function sampleBackground(tempBitmap:Bitmap):void		{			super.sampleBackground(tempBitmap);			_bgImageLoader = null;			}					override protected function drawBackgroundImage():void		{			//TODO this may not work correctly and should be tested			//			if((_backgroundImageBitmap) && (backgroundScale9Grid) && (_backgroundImageBitmap is CamoBitmap))			//					_backgroundImageBitmap["resize"](displayWidth, displayHeight);			super.drawBackgroundImage();		}				internal function addListeners(target : LoaderInfo) : void 		{			target.addEventListener(Event.COMPLETE, onBGImageLoad);			target.addEventListener(IOErrorEvent.IO_ERROR, ioError);		}		internal function removeListeners(target : LoaderInfo) : void 		{			target.removeEventListener(Event.COMPLETE, onBGImageLoad);			target.removeEventListener(IOErrorEvent.IO_ERROR, ioError);			backgroundImageSource = null;		}						internal function ioError(event : IOErrorEvent) : void		{			throw new Error("ERROR: Could not load background image:"+event.text);		}				override public function clearBackground():void		{			if(_bgImageLoader)			{				_bgImageLoader.close();				removeListeners(_bgImageLoader.contentLoaderInfo);				_bgImageLoader = null;			}			super.clearBackground();		}					protected function activateOverflowScroll():void		{					}				protected function activateOverflowAuto():void		{					}					protected function clearOverflow():void		{			if( maskShape ) {				if( maskShape.parent === this ) 					$removeChild( maskShape );				maskShape = null;			}								display.mask = null;		}							override public function set width(value:Number):void		{			super.width = value;			if(maskShape) maskShape.width = _width;		}					override public function get width():Number		{			return maskShape ? borderLeft + paddingLeft + _width + paddingRight + borderRight : super.width;		}					override public function set height(value:Number):void		{			super.height = value;			if(maskShape) maskShape.height = _height;		}				override public function get height():Number		{						return maskShape ? borderTop + paddingTop + _height + paddingBottom + borderBottom : super.height;		}					override public function get displayWidth():Number		{				return maskShape ? maskShape.width :  display.width > _width ? display.width : _width;		}				override public function get displayHeight():Number		{			return maskShape ? maskShape.height : display.height > _height ? display.height : _height		}				// -- Removed, not used		/**		 * <p>This uses reflection to get the Class name.		 * This is helpful for getting the correct type of a CamoDisplay or		 * for referencing any CSS Propertiess set to the ClassName.</p>		 */	/*	public function get className():String{						if(!_className)			{		 		_className = getQualifiedClassName(this).split("::").pop();		 	}		 	return _className;		}*/					public function CamoDisplay() {					}				public function rasterize():void		{						var bmd : BitmapData = new BitmapData(display.width, display.height, true, 0xff0000);				bmd.draw(display);						$removeChild(display);			display.graphics.clear();			display = null;			// add new display			display = new Sprite();			$addChild(display);			display.graphics.beginBitmapFill(bmd.clone(), null, _rasterSmoothing);			display.graphics.drawRect(0, 0, bmd.width, bmd.height);			display.graphics.endFill();						refresh();					}					override public function addChild(child:DisplayObject):DisplayObject		{			/*			if( child )			{				try				{					if( !isNaN( child["_zIndex"] ) )						return addChildAt(child, validateZIndex(child["_zIndex"]));					else						return super.addChild( child );				}				catch( error:Error )				{					return super.addChild(child);				}			}*/			return super.addChild(child);			//return null;		}				override public function get __height():Number {			return maskShape ? _height : super.__height;		}				override public function get __width():Number {			return maskShape ? _width : super.__width;		}				protected function validateZIndex(value:Number):Number		{			return (value > numChildren) ? numChildren : value;		}				protected function $draw():void {			super.draw();		}				override protected function draw():void{							if(maskShape)			{				maskShape.width = _width;				maskShape.height = _height;				maskShape.x = paddingLeft + borderLeft;				maskShape.y = paddingTop + borderTop;			}			super.draw();					}							}}