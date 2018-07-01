// 1 -> player turn
// 2 -> computer turn
var turn = 1;
var prev_turn = 1;

var player_score = 0;
var computer_score = 0;

// 0 -> free cell
// 1 -> players cell
// 2 -> computers cell
var table = [
    [0,0,0],
    [0,0,0],
    [0,0,0]
];


// crea un WebWorker
var computer = new Worker('move.js');




// viene invocato quando il webworker ha finito il processamento,
// l'argomento della funzione di callback contiene il risultato
// dell'elaborazione del webworker
computer.onmessage = function(e) {
    var result = e.data;

    if(result.move){
        // show computer move
        table[result.move.r][result.move.c] = 2;
        $("#matrix_"+result.move.r+"_"+result.move.c).children(".o_img").css({"display":"block"});
    }

    // there's no winner yet
    // it shows computers move and change turn
    if(result.winner==-1){

        // chenge turn
        $("#player_turn").css({"display":"block"});
        $("#computer_turn").css({"display":"none"});
        turn = 1;
        
    }

    // player won
    else if(result.winner==1){
        // change turn & display winner
        $("#player_turn").css({"display":"none"});
        $("#computer_turn").css({"display":"none"});
        $("#player_win").css({"display":"block"});
        $("#new_game").css({"display":"block"});
        turn = 0;

        // update score
        player_score +=1;
        $("#player_score").html(player_score);

        // obfuscates cells
        $(".matrix_cell").css({"opacity":"0.2"});

        // shows result
        $("#matrix_"+result.coords[0][0]+"_"+result.coords[0][1]).css({"opacity":"1"});
        $("#matrix_"+result.coords[1][0]+"_"+result.coords[1][1]).css({"opacity":"1"});
        $("#matrix_"+result.coords[2][0]+"_"+result.coords[2][1]).css({"opacity":"1"});

    }

    // computer won
    else if(result.winner==2){

        // change turn & display winner
        $("#player_turn").css({"display":"none"});
        $("#computer_turn").css({"display":"none"});
        $("#computer_win").css({"display":"block"});
        $("#new_game").css({"display":"block"});
        turn = 0;

        // update score
        computer_score +=1;
        $("#computer_score").html(computer_score);

        // obfuscates cells
        $(".matrix_cell").css({"opacity":"0.2"});

        // shows result
        $("#matrix_"+result.coords[0][0]+"_"+result.coords[0][1]).css({"opacity":"1"});
        $("#matrix_"+result.coords[1][0]+"_"+result.coords[1][1]).css({"opacity":"1"});
        $("#matrix_"+result.coords[2][0]+"_"+result.coords[2][1]).css({"opacity":"1"});

    }

    // tie
    else{
        $(".matrix_cell").css({"opacity":"0.2"});
        $("#player_turn").css({"display":"none"});
        $("#computer_turn").css({"display":"none"});
        $("#tie").css({"display":"block"});
        $("#new_game").css({"display":"block"});
        turn = 0;
    }
    console.log("computer::: "+table.toString());
};





// viene invocata quando il giocatore fa la sua mossa
player_move = function(){
    $("#matrix td").click(function(){
        var id = $(this).attr('id')
        var regexp = /_(\d)_(\d)/
        match = regexp.exec(id)
        var r = parseInt(match[1]);
        var c = parseInt(match[2]);

        if(turn==1 && table[r][c]==0){
            turn = 2;

            $("#player_turn").css({"display":"none"});
            $("#computer_turn").css({"display":"block"});

            table[r][c] = 1;
            $(this).children(".x_img").css({"display":"block"});
            // passo il turno al computer, che dovrà elaborare la
            // mossa da giocare
            computer.postMessage(table);
        }

    });
}





// resetta il campo da gioco per una nuova partita
new_game = function(){
    $("#new_game").click(function(){
        turn = prev_turn==1 ? 2:1;
        prev_turn = turn;
        table = [
            [0,0,0],
            [0,0,0],
            [0,0,0]
        ];

        $(".matrix_cell").css({"opacity":"1"});
        $(".matrix_cell").children(".x_img").css({"display":"none"});
        $(".matrix_cell").children(".o_img").css({"display":"none"});
        $("#new_game").css({"display":"none"});
        $("#player_win").css({"display":"none"});
        $("#computer_win").css({"display":"none"});
        $("#tie").css({"display":"none"});

        if(turn==1){
            $("#player_turn").css({"display":"block"});
            $("#computer_turn").css({"display":"none"});
        }
        else{
            $("#player_turn").css({"display":"none"});
            $("#computer_turn").css({"display":"block"});
            computer.postMessage(table);
        }
    });
}







$(document).ready(function() {

    console.log("ciao ciao");
    player_move();
    new_game();

});