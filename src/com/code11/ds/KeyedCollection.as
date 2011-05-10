package com.code11.ds
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	public class KeyedCollection extends ArrayCollection
	{
		public var key:String = "id";
		
		private var itemByKey:Object = {};
		
		public function KeyedCollection(key:String)
		{
			this.key = key;
			super();
		}
		
		override public function addItem(item:Object):void {
			itemByKey[item[key]] = item; 
			super.addItem(item);
		}
		
		override public function addItemAt(item:Object, index:int):void {
			itemByKey[item[key]] = item;
			super.addItemAt(item,index);
		}
		
		override public function removeItemAt(index:int):Object {
			var item:Object = super.removeItemAt(index);
			delete itemByKey[item[key]];
			return item;
		}
		
		override public function setItemAt(item:Object, index:int):Object {
			var newItemKeyField:* = item[key];
			itemByKey[newItemKeyField] = item;
			var oldItem:Object = super.setItemAt(item, index)[key];
			var oldItemKeyField:* = oldItem[key];
			if (oldItemKeyField != newItemKeyField) {
				delete itemByKey[oldItemKeyField];
			}
			return oldItem;
		}
		
		override public function removeAll():void {
			super.removeAll();
			itemByKey = {};
		}
		
		public function getItemByKey(key:String):Object {
			return itemByKey[key];
		}
		
		override public function set source(s:Array):void {
			super.source = s;
		}
	}
}