// serve solo a rallentare l'esecuzione del worker
function sleep(milliseconds) {
    var start = new Date().getTime();
    for (var i = 0; i < 1e7; i++) {
      if ((new Date().getTime() - start) > milliseconds){
        break;
      }
    }
}


// controlla se sulla tabella da gioco vi è una configurazione
// vincente, in caso positivo restituisce:
// -> il giocatore vincente (result.winner)
// -> un array con le coordinate della mossa vincente (result.coords)
// altrimenti restituisce -1
function check_winner(table){

    var result = {};

    if(table[1][1]==1 || table[1][1]==2){

        var value = table[1][1];
        result.winner = value;

        // first diag
        if(table[0][0]==value && table[2][2]==value){
            result.coords = [[0,0],[1,1],[2,2]];
            return result;
        }

        // second diag
        if(table[2][0]==value && table[0][2]==value){
            result.coords = [[1,1],[2,0],[0,2]];
            return result;
        }

        // central col
        if(table[0][1]==value && table[2][1]==value){
            result.coords = [[1,1],[0,1],[2,1]];
            return result;
        }

        // central row
        if(table[1][0]==value && table[1][2]==value){
            result.coords = [[1,1],[1,0],[1,2]];
            return result;
        }

    }

    if(table[0][0]==1 || table[0][0]==2){

        var value = table[0][0];
        result.winner = value;

        // first col
        if(table[1][0]==value && table[2][0]==value){
            result.coords = [[0,0],[1,0],[2,0]];
            return result;
        }

        // first row
        if(table[0][1]==value && table[0][2]==value){
            result.coords = [[0,0],[0,1],[0,2]];
            return result;
        }
    }

    if(table[2][2]==1 || table[2][2]==2){

        var value = table[2][2];
        result.winner = value;

        // second col
        if(table[0][2]==value && table[1][2]==value){
            result.coords = [[2,2],[0,2],[1,2]];
            return result;
        }

        // second row
        if(table[2][0]==value && table[2][1]==value){
            result.coords = [[2,2],[2,0],[2,1]];
            return result;
        }
    }

    result.winner = -1;
    return result;
}

function empty(table){
    var count = 0;
    for(var r=0;r<3;r++)
        for(var c=0;c<3;c++)
            if(table[r][c] == 0)
                count++;
    return count;
}






// decide la prossima mossa in base ad un semplice algoritmo
function make_move(table){

    if(empty(table)==0)
        return null;

    var aux_table = [[],[],[]];
    var move = {};
    for(var r=0;r<3;r++)
        for(var c=0;c<3;c++){
            if(table[r][c]==0)aux_table[r][c] = 1;
            if(table[r][c]==1)aux_table[r][c] = 5;
            if(table[r][c]==2)aux_table[r][c] = 3;
        }
    
    // Mossa vincente. Quando il prodotto è pari a 9 ( ossia 3x3x1)
    // individua una "mossa vincente" e il gioco finisce.

    // righe
    for(var r=0;r<3;r++){
        if (aux_table[r].reduce(function(a,b){return a*b}) == 9)
            for(var c=0;c<3;c++)
                if(aux_table[r][c]==1){
                    // mossa vincente trovata
                    move.r = r;
                    move.c = c;
                    return move;

                }
    }

    // colonne
    for(var c=0;c<3;c++){
        if(aux_table[0][c]*aux_table[1][c]*aux_table[2][c] == 9)
            for(var r=0;r<3;r++)
                if(aux_table[r][c]==1){
                    // mossa vincente trovata
                    move.r = r;
                    move.c = c;
                    return move;
                }
    }

    // diag1
    if(aux_table[0][0]*aux_table[1][1]*aux_table[2][2] == 9){
        if(aux_table[0][0] == 1){
            move.r = 0;
            move.c = 0;
            return move;
        }
        if(aux_table[1][1] == 1){
            move.r = 1;
            move.c = 1;
            return move;
        }
        if(aux_table[2][2] == 1){
            move.r = 2;
            move.c = 2;
            return move;
        }
    }

    // diag2
    if(aux_table[2][0]*aux_table[1][1]*aux_table[0][2] == 9){
        if(aux_table[2][0] == 1){
            move.r = 2;
            move.c = 0;
            return move;
        }
        if(aux_table[1][1] == 1){
            move.r = 1;
            move.c = 1;
            return move;
        }
        if(aux_table[0][2] == 1){
            move.r = 0;
            move.c = 2;
            return move;
        }
    }
    // Mossa bloccante. Quando il prodotto è pari a 25 (ossia 5x5x1) ,
    // individua la mossa per bloccare il giocatore avversario (B).
    // righe

    for(var r=0;r<3;r++){
        if (aux_table[r].reduce(function(a,b){return a*b}) == 25)
            for(var c=0;c<3;c++)
                if(aux_table[r][c]==1){
                    
                    move.r = r;
                    move.c = c;
                    return move;

                }
    }

    // colonne
    for(var c=0;c<3;c++){
        if(aux_table[0][c]*aux_table[1][c]*aux_table[2][c] == 25)
            for(var r=0;r<3;r++)
                if(aux_table[r][c]==1){
                    // mossa vincente trovata
                    move.r = r;
                    move.c = c;
                    return move;
                }
    }

    // diag1
    if(aux_table[0][0]*aux_table[1][1]*aux_table[2][2] == 25){
        if(aux_table[0][0] == 1){
            move.r = 0;
            move.c = 0;
            return move;
        }
        if(aux_table[1][1] == 1){
            move.r = 1;
            move.c = 1;
            return move;
        }
        if(aux_table[2][2] == 1){
            move.r = 2;
            move.c = 2;
            return move;
        }
    }

    // diag2
    if(aux_table[2][0]*aux_table[1][1]*aux_table[0][2] == 25){
        if(aux_table[2][0] == 1){
            move.r = 2;
            move.c = 0;
            return move;
        }
        if(aux_table[1][1] == 1){
            move.r = 1;
            move.c = 1;
            return move;
        }
        if(aux_table[0][2] == 1){
            move.r = 0;
            move.c = 2;
            return move;
        }
    }
    
    // Altrimenti l'algoritmo sceglie una casella nelle righe, colonne e 
    // diagonali con prodotto uguale a 3.
    // righe
    for(var r=0;r<3;r++){
        if (aux_table[r].reduce(function(a,b){return a*b}) == 3)
            for(var c=0;c<3;c++)
                if(aux_table[r][c]==1){

                    move.r = r;
                    move.c = c;
                    return move;

                }
    }

    // colonne
    for(var c=0;c<3;c++){
        if(aux_table[0][c]*aux_table[1][c]*aux_table[2][c] == 3)
            for(var r=0;r<3;r++)
                if(aux_table[r][c]==1){

                    move.r = r;
                    move.c = c;
                    return move;
                }
    }

    // diag1
    if(aux_table[0][0]*aux_table[1][1]*aux_table[2][2] == 3){
        if(aux_table[0][0] == 1){
            move.r = 0;
            move.c = 0;
            return move;
        }
        if(aux_table[1][1] == 1){
            move.r = 1;
            move.c = 1;
            return move;
        }
        if(aux_table[2][2] == 1){
            move.r = 2;
            move.c = 2;
            return move;
        }
    }

    // diag2
    if(aux_table[2][0]*aux_table[1][1]*aux_table[0][2] == 3){
        if(aux_table[2][0] == 1){
            move.r = 2;
            move.c = 0;
            return move;
        }
        if(aux_table[1][1] == 1){
            move.r = 1;
            move.c = 1;
            return move;
        }
        if(aux_table[0][2] == 1){
            move.r = 0;
            move.c = 2;
            return move;
        }
    }

    // Se non ci sono, allora l'algoritmo seleziona una casella a caso ( scelta random ) tra quelle ancora vuote.
    for(r=0;r<3;r++)
        for(c=0;c<3;c++){
            if(aux_table[r][c]==1){
                move.r = r;
                move.c = c;
                return move;
            }
        }

}


// serve a contare le caselle ancora libere nella tabella
function empty_cells(table){
    var count = 0;
    for(var r=0;r<3;r++)
        for(var c=0;c<3;c++)
            if(table[r][c]==0)
                count++;
    return count;
}


// viene invocata quando lo script principale invia un messaggio
// al web worker tramite Worker.postMessage(data).
// IL worker elabora la richiesta e restituisce il risultato allo script
// principale utilizzando il metodo postMessage(data)
onmessage = function(e){

    var table = e.data;
    var result = {};

    var move = make_move(table);
    if(move){
        table[move.r][move.c] = 2;
        result.move = move;
    }
    check = check_winner(table);
    result.winner = check.winner;
    if(check.coords)
        result.coords = check.coords;

    if(empty_cells(table)==0 && check.winner==-1)
        result.winner = 0;
    
    
    sleep(2000);
    postMessage(result);
    return;

}