import QtQuick 2.0

/*
    Drawing the grid in Canvas. Lame
*/


Canvas {
    id: canvas

    property int gridRows: Math.round(pattern.patternLength * pattern.patternLpb)
    property int gridColumns: 128
    property int gridWidth: noteWidth
    property int gridHeight: 40

    height: gridRows * gridHeight
    width: gridColumns * gridWidth

    // Uncomment below lines to use OpenGL hardware accelerated rendering.
    // See Canvas documentation for available options.
    renderTarget: Canvas.FramebufferObject
    renderStrategy: Canvas.Threaded


    function drawBackground(ctx) {
        //ctx.save();
        //ctx.fillStyle = grid_color;
        //ctx.fillRect(0, 0, canvas.width, canvas.height);
        ctx.strokeStyle = gridline_color;
        // Horizontal grid lines
        for (var i = 0; i < gridRows; i++) {
            ctx.beginPath();
            ctx.moveTo(0,  i * gridHeight);
            if (i%pattern.patternLpb==0){
                ctx.lineWidth = 3;
            }

            ctx.lineTo(canvas.width, i * gridHeight);
            ctx.stroke()
            if (i%pattern.patternLpb==0){
                ctx.lineWidth = 1;
            }

        }

        // Vertical grid lines
        for (i = 0; i < gridColumns; i++) {
            ctx.beginPath();
            ctx.moveTo(i * gridWidth, 0);
            if (i%12==0){
                ctx.lineWidth = 2;
            }
            ctx.lineTo(i * gridWidth, canvas.height);
            ctx.stroke();
            if (i%12==0){
                ctx.lineWidth = 1;
            }
        }


        //ctx.restore();
    }




    onPaint: {
        var ctx = getContext("2d")

        ctx.lineWidth = 1
        ctx.globalAlpha = 1

        drawBackground(ctx)

    }
}



