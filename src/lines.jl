
function insert_lines!(js_scene, points)
    evaljs(js_scene, @js begin
        @var points = $(points[]);
        n=points.length
        @var scene = this.scene
        @var THREE = this.THREE
        @var material = @new THREE.LineBasicMaterial(d(
            color = "#ffffff"
        ));
        @var geometry = @new THREE.BufferGeometry();
        @var pos = @new Float32Array(n*3)
        geometry.addAttribute("position", @new THREE.BufferAttribute( pos,3 ));
        geometry.dynamic = true;
        scene.add(@new THREE.Line(geometry, material))
        positions = geometry.attributes.position.array


        for i=0:n-1
            # TODO can we directly serialize this as a Vector3?
            #geometry.vertices.push(@new(THREE.Vector3(points[i][0], points[i][1], points[i][2])))
            positions[i*3] = points[i][0]
            positions[i*3+1] = points[i][1]
            positions[i*3+2] = points[i][2]
            #geometry.addAttribute( "color", @new THREE.Float32BufferAttribute(
            #                        [points[i][0], points[i][1], points[i][2]], 3));

        end
        geometry.computeBoundingSphere();


    end)
end


w = Window()
#js_scene = ThreeScene();
js_scene = ThreeScreen();
tools(w)
body!(w, js_scene.context(dom"div#container"()))
points = Observable(js_scene.context, "points", tuple.(rand(10).* 10, rand(10).* 10, rand(10).* 10))
insert_lines!(js_scene.context, points)
