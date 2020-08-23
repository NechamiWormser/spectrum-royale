package com.unhurdle.spectrum
{
	COMPILE::JS
  {
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.core.WrappedHTMLElement;
  }
  public class SplitView extends Group
  {
    /**
     * <inject_script>
     * var link = document.createElement("link"); 
     * link.setAttribute("rel", "stylesheet");
     * link.setAttribute("type", "text/css");
     * link.setAttribute("href", "assets/css/components/splitview/dist.css");
     * document.head.appendChild(link);
     * </inject_script>
     */
    public function SplitView()
    {
      super();
    }
    override protected function getSelector():String{
        return "spectrum-SplitView";
    }
		protected var splitter:HTMLDivElement;
		
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement{
			var elem:WrappedHTMLElement = addElementToWrapper(this,'div');
			splitter = newElement('div') as HTMLDivElement;
			splitter.className = appendSelector("-splitter");
			return elem;
		}

		private var _isDraggable:Boolean;

		public function get isDraggable():Boolean
		{
			return _isDraggable;
		}

		public function set isDraggable(value:Boolean):void
		{
				value? splitter.classList.add("is-draggable"): splitter.classList.remove("is-draggable");
				_isDraggable = value;
				COMPILE::JS{
					if(!!_isDraggable){
						if(!splitter.children.length){
							splitter.appendChild(newElement("div",appendSelector("-gripper")));
							splitter.addEventListener("mousedown",onMouseDown);
						}
					}
					if(!_isDraggable){
						if(!!splitter.children.length){
							splitter.removeChild(splitter.children[0]);
						}
							splitter.removeEventListener("mousedown",onMouseDown);
					}
				}
		}
		protected function positionElements(val:Number):void{
			positionCollapsed = val;
			var percent:Number = val;
			COMPILE::JS{
				if(element.children && element.children[2]){
					if(direction === "horizontal"){
						element.children[0].style.width = percent + "%";
						splitter.style.left = "0";
						element.children[2].style.width = (100 - percent) + "%";
					}else{
						element.children[0].style.height = percent + "%";
						splitter.style.top = "0";
						element.children[2].style.height = (100 - percent) + "%";
					}
				}
			}
		}
		private var _position:Number;

		public function get position():Number
		{
			return _position;
		}

		public function set position(value:Number):void
		{
			if(!isNaN(value)){
				_position = value;
				positionElements(value);
				positionCollapsed = value;
			}
		}

		private var _positionCollapsed:Number;
		private function get positionCollapsed():Number
		{
			return _positionCollapsed;
		}
		private function set positionCollapsed(value:Number):void
		{
			if(value != _positionCollapsed){
				var oldpositionCollapsed:String;
				if(_positionCollapsed < 1){
					oldpositionCollapsed = "is-collapsed-start";
					splitter.classList.remove(oldpositionCollapsed);
				} else if(_positionCollapsed > 99){
					oldpositionCollapsed = "is-collapsed-end";
					splitter.classList.remove(oldpositionCollapsed);
				}
				if(value < 1 || value > 99){
					var newpositionCollapsed:String;
					if(value < 1){
						newpositionCollapsed = "is-collapsed-start";
					} else{
						newpositionCollapsed = "is-collapsed-end";
					}
					splitter.classList.add(newpositionCollapsed);
					_positionCollapsed = value;
				}
			}
		}

		private var _direction:String;
		protected function get direction():String
		{
			return _direction;
		}
		protected function set direction(value:String):void
		{
				switch (value){
					case "vertical":
					case "horizontal":
						break;
					default:
						throw new Error("Invalid direction: " + value);
				}
				if(_direction){
					toggle(valueToSelector(_direction), false);
				}
				
				toggle(valueToSelector(value), true);
				_direction = value;
		}
		private function onMouseDown(e: MouseEvent):void{
			COMPILE::JS{
				e.preventDefault();
				e.stopImmediatePropagation();
    		window.addEventListener('mouseup', onMouseUp);
    		element.addEventListener('mousemove', onMouseMove);	
			}
		}
		private function onMouseUp(e: MouseEvent):void{
			COMPILE::JS{
				window.removeEventListener('mouseup', onMouseUp);
				element.removeEventListener('mousemove', onMouseMove);		
			}
		}
		private function onMouseMove(e: MouseEvent):void{
			COMPILE::JS{
				var percent:Number;
				var clientRect:ClientRect = element.getBoundingClientRect();
				if(direction == "horizontal"){
					var sliderLeft:Number = clientRect.left;
					var sliderWidth:Number = clientRect.width;
					var x:Number = Math.max(Math.min(e.clientX - sliderLeft, sliderWidth), 0);
					percent = (x / sliderWidth) * 100;
				} else{
					var sliderTop:Number = clientRect.top;
					var sliderHeight:Number = clientRect.height;
					var y:Number = Math.max(Math.min(e.clientY - sliderTop, sliderHeight), 0);
					percent = (y / sliderHeight) * 100;
				}
				_position = percent;
				positionElements(percent);
			}
		}
		COMPILE::JS
		public override function addElement(c:org.apache.royale.core.IChild, dispatchEvent:Boolean = true):void{
			super.addElement(c,dispatchEvent);
			c.element.classList.add(appendSelector("-pane"));
			positionElements(position);
			if(element.children.length == 1){
				element.appendChild(splitter);
			}
			if(this is HSplitView){
				(this as HSplitView).leftVisible = (this as HSplitView).leftVisible;
				(this as HSplitView).rightVisible = (this as HSplitView).rightVisible;
			} else{
				(this as VSplitView).topVisible = (this as VSplitView).topVisible;
				(this as VSplitView).bottomVisible = (this as VSplitView).bottomVisible;
			}
		}
  }
}