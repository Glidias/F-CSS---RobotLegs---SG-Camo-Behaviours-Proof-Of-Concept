﻿/**
 * Object Pool V1.1
 * Copyright (c) 2008 Michael Baczynski, http://www.polygonal.de
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package sg.camogxml.render
{
	import sg.camo.interfaces.IDisplayRender;
	import sg.camo.interfaces.IRenderFactory;
	import sg.camo.interfaces.IRenderPool;
	
	/**
	 * Original class and execution by Michael Baczynski, http://www.polygonal.de.
	 * under de.polygonal.core.ObjectPool. 
	 * <br/><br/>
	 * Migrated to CamoGXML and designed to strict-type to IDisplayRenders instances.
	 * <br/><br/>
	 * 
	 * 
	 * @see sg.camo.interafaces.IDisplayRender
	 * 
	 * @author Glenn Ko
	 */
	public class RenderPool implements IRenderPool
	{
		private var _factory:IRenderFactory;
		
		private var _initSize:int;
		private var _currSize:int;
		private var _usageCount:int;
		
		private var _grow:Boolean = true;
		
		private var _head:RenderNode;
		private var _tail:RenderNode;
		
		private var _emptyNode:RenderNode;
		private var _allocNode:RenderNode;
		
		protected var _lastRendered:IDisplayRender;
		
		public function get deconstructed():Boolean {
			return _emptyNode == null;
		}
		
		/**
		 * Creates a new object pool.
		 * 
		 * @param grow If true, the pool grows the first time it becomes empty.
		 */
		public function RenderPool(grow:Boolean = false)
		{
			_grow = grow;
		}

		/**
		 * Unlock all ressources for the garbage collector.
		 */
		public function deconstruct():void
		{
			var node:RenderNode = _head;
			var t:RenderNode;
			while (node)
			{
				t = node.next;
				node.next = null;
				node.data = null;
				node = t;
			}
			
			_head = _tail = _emptyNode = _allocNode = null;
			_lastRendered = null;
		}
		
		/**
		 * The pool size.
		 */
		public function get size():int
		{
			return _currSize;
		}
		
		/**
		 * The total number of 'checked out' objects currently in use.
		 */
		public function get usageCount():int
		{
			return _usageCount;
		}
		
		/**
		 * The total number of unused thus wasted objects. Use the purge()
		 * method to compact the pool.
		 * 
		 * @see #purge
		 */
		public function get wasteCount():int
		{
			return _currSize - _usageCount;	
		}
		
		/**
		 * Get the next available IDisplayRender from the pool or put it back for the
		 * next use. If the pool is empty and non-resizable, will return the last retrieved IDisplayRender.
		 */
		public function get object():IDisplayRender
		{
			var o:IDisplayRender;
			if (_usageCount == _currSize)
			{
				if (_grow)  
				{
					_currSize += _initSize;
					
					var n:RenderNode = _tail;
					var t:RenderNode = _tail;
					
					var node:RenderNode;
					for (var i:int = 0; i < _initSize; i++)
					{
						node = new RenderNode();
						o = _factory.createRender();
		
						node.data = o;
						
						t.next = node;
						t = node; 
					}
					
					_tail = t;
					
					_tail.next = _emptyNode = _head;
					_allocNode = n.next;
					_lastRendered = o;
					_usageCount++;
					return o;
				}
 				else {
					trace("RenderPool() WARNING!!! Object pool exhausted. Returning last rendered instance.");
					return _lastRendered;
					//throw new Error("object pool exhausted.");
				}
			}
			else
			{
				o = _allocNode.data;
				_allocNode.data = null;
				_allocNode = _allocNode.next;
				_usageCount++
				_lastRendered = o;
				return o;
			}
		}
		
		/**
		 * @private
		 */
		public function set object(o:IDisplayRender):void
		{
			if (_usageCount > 0)
			{
				_usageCount--;
				_emptyNode.data = o;
				_emptyNode = _emptyNode.next;
			}
		}
		
		/**
		 * Define the factory responsible for creating all pool objects.
		 * If you don't want to use a factory, you must provide a class to the
		 * allocate method instead.
		 * 
		 * @see #allocate
		 */
		public function setFactory(factory:IRenderFactory):void
		{
			_factory = factory;
		}

		/**
		 * Allocate the pool by creating all objects from the factory. 
		 * 
		 * @param size The number of objects to create.
		 * @param C    The class to create for each object node in the pool.
		 *             This overwrites the current factory.
		 */
		public function allocate(size:uint, C:Class = null):void
		{
			deconstruct();
			
			if (C)
				_factory = new SimpleFactory(C);
			else
				if (!_factory)
					throw new Error("nothing to instantiate.");	
			
			_initSize = _currSize = size;
			
			_head = _tail = new RenderNode();
			_head.data = _factory.createRender();
			
			var n:RenderNode;
			
			for (var i:int = 1; i < _initSize; i++)
			{
				n = new RenderNode();
				n.data = _factory.createRender();
				n.next = _head;
				_head = n;
			}

			_emptyNode = _allocNode = _head;
			_tail.next = _head;			
		}
		
		/*
		/*
		 * Helper method for applying a function to all objects in the pool.
		 * 
		 * @param func The function's name.
		 * @param args The function's arguments.
		 *
		
		 public function initialze(func:String, args:Array):void
		{
			var n:RenderNode = _head;
			while (n)
			{
				n.data[func].apply(n.data, args);
				if (n == _tail) break;
				n = n.next;	
			}
		}
		*/
		
		/**
		 * Remove all unused objects from the pool. If the number of remaining
		 * used objects is smaller than the initial capacity defined by the
		 * allocate() method, new objects are created to refill the pool. 
		 * Also cleans up last rendered IDisplayRender cache.
		 */
		public function purge():void
		{
			_lastRendered = null;
			
			var i:int;
			var node:RenderNode;
			
			if (_usageCount == 0)
			{
				if (_currSize == _initSize)
					return;
					
				if (_currSize > _initSize)
				{
					i = 0; 
					node = _head;
					while (++i < _initSize)
						node = node.next;	
					
					_tail = node;
					_allocNode = _emptyNode = _head;
					
					_currSize = _initSize;
					return;	
				}
			}
			else
			{
				var a:Array = [];
				node =_head;
				while (node)
				{
					if (!node.data) a[int(i++)] = node;
					if (node == _tail) break;
					node = node.next;	
				}
				
				_currSize = a.length;
				_usageCount = _currSize;
				
				_head = _tail = a[0];
				for (i = 1; i < _currSize; i++)
				{
					node = a[i];
					node.next = _head;
					_head = node;
				}
				
				_emptyNode = _allocNode = _head;
				_tail.next = _head;
				
				if (_usageCount < _initSize)
				{
					_currSize = _initSize;
					
					var n:RenderNode = _tail;
					var t:RenderNode = _tail;
					var k:int = _initSize - _usageCount;
					for (i = 0; i < k; i++)
					{
						node = new RenderNode();
						node.data = _factory.createRender();
						
						t.next = node;
						t = node; 
					}
					
					_tail = t;
					
					_tail.next = _emptyNode = _head;
					_allocNode = n.next;
					
				}
			}
		}
	}
}


import sg.camo.interfaces.IDisplayRender;


internal class RenderNode
{
	public var next:RenderNode;
	
	public var data:IDisplayRender;
}

import sg.camo.interfaces.IRenderFactory;

internal class SimpleFactory implements IRenderFactory
{
	private var _class:Class;
	
	public function SimpleFactory(C:Class)
	{
		_class = C;
	}

	public function createRender():IDisplayRender
	{
		return new _class() as IDisplayRender;
	}
}