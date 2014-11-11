(function($){

$.fn.jooSlider = function(options) {  
 
        var opt = {
            auto:true,
            speed:5000
        };
 
            if (options) { 
                $.extend(opt, options);
            }
            
            var container = $(this);

            var Slider  = function(){

                //===========
                // Variables
                //===========
                var block = false;                                  // Empêcher le clique multiple
                var height = container.find('img').height();             // Hauteur des images
                container.find('img').wrap('<div class="img-wrap"></div>');            
                this.imgs = container.find('.img-wrap');
                this.imgCount = (this.imgs.length) - 1;

                /* Caption */
                this.imgs.each(function(){
                    var caption = $(this).find('img').attr('title');
                    $(this).append('<p>'+caption+'</p>');
                });
                this.captions = container.find('.img-wrap').find('p');

                /* Controls */

                container.append('<div id="controls"><a href="#" id="prev"></a><a href="#" id="next"></a></div>');
                this.navigNext =  $('#next');
                this.navigPrev =  $('#prev');

                /* navigigation */

                container.after('<div class="navig" />');
                var navig = $(".navig");
                this.imgs.each(function(){
                    var caption = $(this).find('img').attr('title');
                    navig.append('<a href="#">'+ caption +'</a>');
                });
                this.bullets = navig.find("a");


                //==========
                // Méthodes
                //==========


                /*
                *   Méthode qui retourne l'index de la div.current
                */

                this.getCurrentIndex = function(){
                    return this.imgs.filter('.current').index();
                };

                /*
                *   Méthode qui anime le slide de haut en bas ou de bas en haut
                */

                this.goNext = function(index){

                    /* Images */
                    this.imgs.filter(".current").stop().animate({   // Monte l'image current
                        "top": -height+ "px"
                    }, function(){
                        $(this).hide();
                        $(this).find('p').hide();
                    });
                    this.imgs.removeClass("current");   // Supprime classe current
                    var cap = this.captions.eq(index);
                    this.imgs.eq(index).css({           // Monte la suivante et attribut la classe current
                        "top": height+"px"
                    }).show().stop().animate({
                        "top": "0px"
                    },function(){block=false;cap.fadeIn();}).addClass("current");

                    
                    /* Bullets */
                    this.bullets.removeClass("current").eq(index).addClass("current");

                }; //////////////////////// END GO NEXT

                this.goPrev = function(index){

                    /* Images */
                    this.imgs.filter(".current").stop().animate({ 
                        "top": height+ "px"
                        }, function(){
                            $(this).hide();
                            $(this).find('p').hide();
                            block=false;
                        });
                    this.imgs.removeClass("current");
                    var cap = this.captions.eq(index);
                    this.imgs.eq(index).css({           
                        "top": -height+"px"
                    }).show().stop().animate({
                        "top": "0px"
                    }, function(){cap.fadeIn();}).addClass("current");



                    /* Bullets */
                    this.bullets.removeClass("current").eq(index).addClass("current");

                }; //////////////////////// END GO PREV

                this.next = function(){

                    var index = this.getCurrentIndex();
                    if (index < this.imgCount) { 
                        if(block !==true){
                            this.goNext(index + 1); // Go next 
                        }
                        } else { 
                            if(block !==true){
                                this.goNext(0); // If last go first 
                            }  
                        } 
                    block = true;

                }; //////////////////////// END NEXT

                this.prev = function(){

                    var index = this.getCurrentIndex();
                    if (index > 0) { 
                        if(block !== true){
                            this.goPrev(index - 1); // Go previous 
                        } 
                        } else { 
                            if(block !== true){
                            this.goPrev(this.imgCount); // If first go last     
                            }
                        } 
                    block = true;

                }; //////////////////////// END PREV



                /*
                *   Méthode qui initialise l'objet
                */

                this.init = function(){
                    this.imgs.hide().first().addClass('current').show();
                    this.bullets.first().addClass("current");
                    this.captions.first().fadeIn();
                };

            }; // End Slider Object


            var slider = new Slider();
            slider.init();

            //==========
            //  EVENTS
            //==========

            /* Click */

            slider.navigNext.click(function(e){ // Click next button
                e.preventDefault();
                clearInterval(interval);
                interval = setInterval(timer, opt.speed); 
                slider.next();
            });

            slider.navigPrev.click(function(e){ // Click previous button
                e.preventDefault();
                slider.prev();
                clearInterval(interval);
                interval = setInterval(timer, opt.speed);
            });

            slider.bullets.click(function(e){  // Click numbered bullet
                e.preventDefault(); 
                var imgIndex = slider.getCurrentIndex();
                var bulletIndex = $(this).index();
                if(imgIndex < bulletIndex){
                    slider.goNext(bulletIndex);
                }else{
                    slider.goPrev(bulletIndex);
                }                
                clearInterval(interval);
                interval = setInterval(timer, opt.speed);
            });

            /* Interval */
            var interval = setInterval(timer, opt.speed);
            if(opt.auto === true){
                var timer = function(){slider.next();};
            }
            container.hover(function(){
              clearInterval(interval);
            }, function(){
              clearInterval(interval);
              interval = setInterval(timer, opt.speed);
            });


            return this;

    }; // End Plugin


})(jQuery);



$(document).ready(function(){
        $("#slider").jooSlider({
            auto:true,
            speed:7000
        });
    });