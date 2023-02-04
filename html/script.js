// safe best by pwais#4019

window.addEventListener('message', (event) => {
    if (event.data.type === 'open') {
        $(".background").fadeIn()
    }

    if (event.data.type === 'infos') {
        firstname = event.data.firstname
        lastname = event.data.lastname
        job = event.data.job,
        bank = event.data.bank,
        cash = event.data.cash,
        bankid = event.data.bankid,
        profilepicture = event.data.profilepicture
        accountbox()
    }
     
    let id = 1
    if (event.data.type === 'log') {
        id = id + 1
        console.log(event.data.profilepicture)

        if (event.data.iban === "BANK") {
            image = 'img/master-car.png'
        } else {
            image = event.data.profilepicture
        }

        html = `
            <div class="islemler-container">
                <div class="photo">
                    <div class="image" style="background-image: url(`+ image +`);"></div>
                </div>
                <div class="texts">
                    <div class="header">
                    <p>`+ event.data.name +`</p>
                    </div>
                    <div class="detail">
                    <p>`+ event.data.action +`</p>
                    </div>
                </div>
                <div class="card-number">
                    <p>•••• `+ event.data.iban +`</p>
                </div>
                <div class="miktar">
                    <p style="color: #`+ event.data.renk +`">`+ event.data.para +`,00 USD</p>
                </div>
            </div>
        `

        $('.islemler').prepend(html);
    }

    if (event.data.type === 'logtransfer') {
        html = `
            <div class="son-transfer-alt-container">
                <div class="image" style="background-image: url(`+event.data.foto+`)"></div>
                <div class="name-detail">
                    <p>`+event.data.name+`</p>
                </div>
                <div class="input">
                    <input id="`+event.data.iban+`input" type="number" placeholder="00.00"><span>$</span>
                </div>
                <div class="button">
                    <button id="`+event.data.iban+`" class="sontransferparagonder">Gönder</button>
                </div>
            </div>
        `

        $('#doldurknk').prepend(html);
    }

    if (event.data.type === 'addbill') {
        html = `
            <div id="`+event.data.billid+`" class="debt-container" style="border-bottom: 2px solid rgba(255, 255, 255, 0.178);">
                <div class="image"></div>
                <div class="text"><p>`+event.data.label+`</p></div>
                <div class="cdebt"><p>`+event.data.money+` $</p></div>
                <div class="button"> <button id="`+event.data.billid+`" class="payinvoice">Hepsini Öde</button></div>
            </div>
        `

        $('#faturadoldur').prepend(html);
    }
    
    if (event.data.type === 'clearui') {
        $('#son').empty();
        $('#faturadoldur').empty();
        $('#doldurknk').empty();
    }
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESCAPE
        $(".background").fadeOut()
        $.post('http://pw-bank2/closeapp', JSON.stringify({}));
        break;
    }
});

function accountbox() {
    abank = Math.abs(bank).toLocaleString();
    acash = Math.abs(cash).toLocaleString();

    $("#name1").html(firstname + " " + lastname);
    $(".username2").html(firstname + " " + lastname);
    $("#mymoney").html(bank + ",00 $");
    $("#cardmoney").html(bank + ",00 $");
    $("#iban").html("•••• " + bankid);
    $("#iban2").html("•••• " + bankid);
    $("#profilepicture").css('background-image', 'url('+profilepicture+')')
}

$("#hzlcek100").click(function(){


    $.post('http://pw-bank2/cek', JSON.stringify({
        para: 100
    }));
});

$("#hzlcek500").click(function(){
    

    $.post('http://pw-bank2/cek', JSON.stringify({
        para: 500
    }));
});

$("#hzlcek1000").click(function(){
    

    $.post('http://pw-bank2/cek', JSON.stringify({
        para: 1000
    }));
});

$("#hzlyatir100").click(function(){


    $.post('http://pw-bank2/yatir', JSON.stringify({
        para: 100
    }));
});

$("#hzlyatir500").click(function(){
    

    $.post('http://pw-bank2/yatir', JSON.stringify({
        para: 500
    }));
});

$("#hzlyatir1000").click(function(){
    

    $.post('http://pw-bank2/yatir', JSON.stringify({
        para: 1000
    }));
});


$("#miktargircek").click(function(){
    var para = $("#withdrawcustominput").val()

    $.post('http://pw-bank2/cek', JSON.stringify({
        para: para
    }));

    $("#withdrawcustominput").val("")
});


$("#miktargityatir").click(function(){
    var para = $("#depositcustominput").val()

    $.post('http://pw-bank2/yatir', JSON.stringify({
        para: para
    }));

    $("#depositcustominput").val("")
});

$(".parayigonder").click(function() {
    var iban = $("#transfermiktar").val()
    if ( iban.length == "4" ) {
        $.post('http://pw-bank2/transfer', JSON.stringify({
                iban: $("#transfermiktar").val(),
                para: $("#transferpara").val()
            })
        );

        $("#transfermiktar").val("")
        $("#transferpara").val("")
    }
}); 

$(document).on('click', '.payinvoice', function(event){
    var thisid = this.id

    $.post('http://pw-bank2/PayInvoice', JSON.stringify({
        invoiceId: thisid
    }));
});

$(".sontransferparagonder").click(function() {
    var thisid = this.id
   $.post('http://pw-bank2/transfer', JSON.stringify({
           iban: $("#"+this.id+"").val(),
           para: $("#"+this.id+"input").val()
       })
   );
   $("#"+thisid+"input").val("")
}); 