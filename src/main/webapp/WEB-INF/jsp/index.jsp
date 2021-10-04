<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href='http://fonts.googleapis.com/css?family=Roboto:300,400,500,700,900' rel='stylesheet' type='text/css'>

    <!-- Page title -->
    <title>Exchange Rate Calculate</title>

    <!-- Vendor styles -->
    <link rel="stylesheet" href="/resources/luna/vendor/fontawesome/css/font-awesome.css"/>
    <link rel="stylesheet" href="/resources/luna/vendor/animate.css/animate.css"/>
    <link rel="stylesheet" href="/resources/luna/vendor/bootstrap/css/bootstrap.css"/>
    <link rel="stylesheet" href="/resources/luna/vendor/toastr/toastr.min.css"/>

    <!-- App styles -->
    <link rel="stylesheet" href="/resources/luna/styles/pe-icons/pe-icon-7-stroke.css"/>
    <link rel="stylesheet" href="/resources/luna/styles/pe-icons/helper.css"/>
    <link rel="stylesheet" href="/resources/luna/styles/stroke-icons/style.css"/>
    <link rel="stylesheet" href="/resources/luna/styles/style.css">
</head>
<body>

<!-- Wrapper-->
<div class="wrapper">


    <!-- Main content-->
    <section class="content">

        <div class="container-center animated slideInDown">

            <div class="view-header">
                <div class="header-icon">
                    <i class="pe page-header-icon pe-7s-refresh-2"></i>
                </div>
                <div class="header-title">
                    <h1>환율계산</h1>
                </div>
            </div>

            <div class="panel panel-filled">
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-form-label" for="remittanceCountry">송금국가</label>
                        <input type="text" id="remittanceCountry" name="remittanceCountry" value="미국(USD)" class="form-control" readonly>
                    </div>
                    <div class="form-group">
                        <label class="col-form-label" for="receptionCountry">수취국가</label>
                        <select id="receptionCountry" name="receptionCountry" class="select2_demo_1 form-control">
                            <option value="USDKRW">한국(KRW)</option>
                            <option value="USDJPY">일본(JPY)</option>
                            <option value="USDPHP">필리핀(PHP)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="col-form-label" for="exchangeRate">환율</label>
                        <input type="text" id="exchangeRate" value="" class="form-control" readonly>
                    </div>
                    <div class="form-group">
                        <label class="col-form-label" for="remittanceAmount">송금액(USD)</label>
                        <input type="text" id="remittanceAmount" value="" class="form-control" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');">
                    </div>
                    <div>
                        <button class="btn btn-accent" id="submit" onclick="submit_click();">Submit</button>
                    </div>
                    <div class="form-group" id="finalExchangeRateArea" style="display:none;">
                        <label class="col-form-label" for="finalExchangeRate"></label>
                        <input type="text" id="finalExchangeRate" value="" class="form-control" readonly>
                    </div>
                </div>
            </div>

        </div>
    </section>
    <!-- End main content-->

</div>
<!-- End wrapper-->

<!-- Vendor scripts -->
<script src="/resources/luna/vendor/pacejs/pace.min.js"></script>
<script src="/resources/luna/vendor/jquery/dist/jquery.min.js"></script>
<script src="/resources/luna/vendor/bootstrap/js/bootstrap.min.js"></script>
<script src="/resources/luna/vendor/flot/jquery.flot.min.js"></script>
<script src="/resources/luna/vendor/flot/jquery.flot.resize.min.js"></script>
<script src="/resources/luna/vendor/flot/jquery.flot.spline.js"></script>
<script src="/resources/luna/vendor/toastr/toastr.min.js"></script>
<script src="/resources/luna/vendor/chart.js/dist/Chart.min.js"></script>

<!-- App scripts -->
<script src="scripts/luna.js"></script>

<script>

    $(document).ready(function(){
        getExchangeRate();

        $('#receptionCountry').change(function(e)  {
            getExchangeRate();
            return false;
        });

        toastr.options = {
            "debug": false,
            "newestOnTop": false,
            "positionClass": "toast-bottom-right",
            "closeButton": true,
            "progressBar": true
        };
    });

    let exchangeRate;
    let receptionCountry;
    function getExchangeRate() {
        document.querySelector('#finalExchangeRateArea').style.display = "none";
        let country = document.querySelector('#receptionCountry').value;
        $.ajax({
            url:"/exchange/" + country,
            type: "GET",
            dataType:"JSON",
            success: function(data) {
                if(typeof data == 'string') {
                    data = JSON.parse(data);
                }
                data.forEach(function(item) {
                    exchangeRate = item.exchangeRate;
                    receptionCountry = item.receptionCountry;
                    let finalExchangeRate = decimalPoint(exchangeRate);
                    let exchangeUSD = receptionCountry.substr(3, 6) + '/USD';
                    document.querySelector('#exchangeRate').value = finalExchangeRate + ' ' + exchangeUSD;
                });
            },
            beforeSend:function(){

            },
            complete:function(){

            },
            error: function(errorThrown) {

            }
        });
    }

    function decimalPoint(exchangeRate) {
        let finalExchangeRate = exchangeRate.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

        return finalExchangeRate;
    }

    function submit_click() {
        let remittanceAmount = document.querySelector('#remittanceAmount').value;

        if(remittanceAmount > 10000) {
            toastr.warning('10000이하의 금액을 입력해주세요.');
            return false;
        }

        if(remittanceAmount === '') {
            toastr.warning('송금액을 입력해주세요.');
            return false;
        }

        let reception = remittanceAmount * exchangeRate;
        let finalExchangeRate = decimalPoint(reception);
        document.querySelector('#finalExchangeRate').value = '수취금액은 ' + finalExchangeRate + ' ' + receptionCountry.substr(3, 6) + ' 입니다.';
        document.querySelector('#finalExchangeRateArea').style.display = "block";
    }

</script>
</body>

</html>