import QtQuick 2.0

Canvas {
    id: canvas

    property int gridRows: 128
    property int gridColumns: 128
    property int gridWidth: noteWidth
    property int gridHeight: 40

    height: gridRows * gridHeight
    width: gridColumns * gridWidth

    // Uncomment below lines to use OpenGL hardware accelerated rendering.
    // See Canvas documentation for available options.
    // renderTarget: Canvas.FramebufferObject
    // renderStrategy: Canvas.Threaded


    function drawBackground(ctx) {
        //ctx.save();
        ctx.fillStyle = "#0d0d0f";
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        ctx.strokeStyle = "#dedede";
        ctx.beginPath();
        // Horizontal grid lines
        for (var i = 0; i < gridRows; i++) {
            ctx.moveTo(0,  i * gridHeight);
            ctx.lineTo(canvas.width, i * gridHeight);
        }
        ctx.stroke()

        // Vertical grid lines
        for (i = 0; i < gridColumns; i++) {
            ctx.moveTo(i * gridWidth, 0);
            ctx.lineTo(i * gridWidth, canvas.height);
        }
        ctx.stroke();

        //ctx.restore();
    }




    onPaint: {
        var ctx = getContext("2d")

        ctx.lineWidth = 1
        ctx.globalAlpha = 0.7

        drawBackground(ctx)

    }
}



