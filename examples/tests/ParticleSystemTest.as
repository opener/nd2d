package tests {
    import de.nulldesign.nd2d.display.ParticleSystem2D;
    import de.nulldesign.nd2d.display.Scene2D;
    import de.nulldesign.nd2d.materials.BlendModePresets;
    import de.nulldesign.nd2d.utils.ParticleSystemPreset;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class ParticleSystemTest extends Scene2D {

        [Embed(source="/assets/particle_small.png")]
        private var particleClass:Class;

        private var particles:ParticleSystem2D;

        private var blah:Sprite;

        public function ParticleSystemTest() {

            particles = new ParticleSystem2D(new particleClass().bitmapData, 3000, new ParticleSystemPreset());
            //particles.scaleX = particles.scaleY = 4.0;
            particles.blendMode = BlendModePresets.ADD;

            addChild(particles);

            addEventListener(Event.ADDED_TO_STAGE, addedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
        }

        private function removedFromStage(e:Event):void {
            if(blah) {
                blah.removeEventListener(MouseEvent.CLICK, resetClick);
                stage.removeChild(blah);
                blah = null;
            }
        }

        private function addedToStage(e:Event):void {

            blah = new Sprite();
            blah.graphics.beginFill(0xFF9900, 10.0);
            blah.graphics.drawCircle(0, 0, 10.0);
            blah.graphics.endFill();
            blah.x = 150;
            blah.y = 10;
            blah.addEventListener(MouseEvent.CLICK, resetClick);
            stage.addChild(blah);
        }

        private function resetClick(e:MouseEvent):void {
            particles.reset();
        }

        override protected function step(elapsed:Number):void {
            particles.x = stage.stageWidth / 2;
            particles.y = stage.stageHeight / 2;
            particles.gravity.x = (stage.mouseX / stage.stageWidth * 2.0 - 1.0) * 2000.0;
            particles.gravity.y = (stage.mouseY / stage.stageHeight * 2.0 - 1.0) * 2000.0;
            //particles.rotation += 1;
        }
    }
}