/* Mobile First! */
* {
    font-family: 'Montserrat', sans-serif;
}

/* Site-wide Styles - START */
html, body {
    height: 100%;
    margin: 0;
    padding: 0;
    font-size: 12px;
    font-family: 'Droid Sans', sans-serif;
}

body {
    width: 100%;
    background: #fafafa;
}

.container {
    max-width: 1000px;
}

.header {
    background: rgba(18,100,170,.9);
    color: #fff;
    padding: 20px 0 20px 0;
    line-height: 58px;
    border-bottom: 1px solid #7f7f7f;
}

.header .logo {
    text-align: center;
}

.header .brand-name {
    padding-left: 40px;
    font-size: 18px;
    text-transform: uppercase;
}

.header .call {
    font-size: 14px;
    text-align: right;
}

.main {
    background: #fafafa;
}

.sidebar {
    font-size: 16px;
    background: rgba(10,80,161,.8);
    color: #f1f1f1;
    padding: 40px;
    -webkit-box-shadow: inset 0 7px 9px -8px rgba(0,0,0,0.4);
    -moz-box-shadow: inset 0 7px 9px -8px rgba(0,0,0,0.4);
    box-shadow: inset 0 7px 9px -8px rgba(0,0,0,0.4);
}

.sidebar a {
    text-decoration: underline;
    color: #f1f1f1;
}

.sidebar ul {
    line-height: 26px;
}

.sidebar li {
    padding-bottom: 20px;
    max-width: 400px;
}

.form {
    background: #fff;
    padding: 40px 60px;
    display: flex;
    flex-direction: column;
    font-size: 14px;
}

.form p {
    margin: 10px 0 20px 0;
}

.height-full {
    min-height: 80vh;
}

.form .styled-input {
    color: #333;
    height: 44px !important;
    width: 100%;
    border: 1px solid #e3e3e3;
    border-radius: 0 !important;
    padding: 10px 8px;
}

.form .styled-input-button {
    height: 44px !important;
    padding: 8px 14px;
    background: inherit;
    border: 1px solid #e3e3e3;
}

.form .styled-input:focus {
    border: 1px solid #b3b3b3;
}

.moreinfo {
    background: #fafafa;
    text-align: center;
    padding: 50px 0;
    font-size: 14px;
    line-height: 30px;
}

.footer {
    min-height: 200px;
    background: #111111;
    color: #ddd;
    padding: 60px 0 60px 0;
}

.vertical-align {
    display: flex;
    flex-direction: row;
}

.vertical-align > [class^="col-"],
.vertical-align > [class*=" col-"] {
    display: flex;
    align-items: center;     /* Align the flex-items vertically */
}

.language-button {
    outline: none;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    padding: 6px 10px;
    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border-radius: 3px;
    color: #fff !important;
    font-weight: 600 !important;
    border: 1px solid #555555;
    background: #555555;
    font-size: 13px;
    margin-right: -16px;
}

.styled-button {
    outline: none;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    padding: 14px 20px;
    -webkit-border-radius: 4px;
    -moz-border-radius: 4px;
    border-radius: 4px;
    color: #fff !important;
    width: 200px;
    font-weight: 600 !important;
    border: 1px solid #c60218;
    background: #c60218;
    font-size: 13px;
}

label {
    font-size: 14px;
}

h4 {
    font-size: 20px;
}

h2 {
    font-size: 26px;
}

.fieldErrorMessage {
    display: none;
    margin-top: -2px;
    color: #f1f1f1;
    font-size: 12px;
    padding: 2px 6px 0px 10px;
    background: #e84c3d;
    border-bottom-left-radius: 4px;
    border-bottom-right-radius: 4px;
    margin-bottom: 10px;
    line-height: 14px !important;
}

.fieldErrorMessage.filled {
    display: block;
}

.errorMessage {
    padding: 0 0 12px 0;
    margin: -2px 0;
}

.disabled-button {
    background: #e9e9e9 !important;
    pointer-events: none;
    color: #ccc !important;
    border: 1px solid #ccc !important;
    box-shadow: inset 0 -2px #bbb !important;
}

.progress-indicator>li .bubble:after, .progress-indicator>li .bubble:before {
    top: 41px !important;
}

.radio-container input.custom-radio {
    display: none  !important;
}

.radio-container label.custom-radio-label {
    color: #444 !important;
    display: inline-block;
    margin-right: 20px;
    margin-top: 2px;
}

.radio-container span.big {
    background-color: #fafafa !important;
    box-shadow: inset 0 1px 2px rgba(0,0,0,.39) !important;
    border-radius: 50% 50% 50% 50%  !important;
    display: inline-block;
    height: 12px;
    margin-bottom: -8px;
    margin-right: 9px;
    padding: 8px;
    position: relative;
    top: -3px;
    width: 12px;
    -webkit-box-sizing: unset;
    -moz-box-sizing: unset;
    box-sizing: unset;
}

.radio-container span.small {
    border-radius: 50% 50% 50% 50%;
    display: block;
    height: 100%;
    width: 100%;
}

.radio-container input.custom-radio:checked + label.custom-radio-label span.small {
    background-color: #ffffff !important;
}

.radio-container input.custom-radio:checked + label.custom-radio-label span.big {
    background-color: #3a97b5 !important;
}

.radio-container label.circle span.big{
    height: 8px;
    width: 8px;
    padding : 4px;
    border:2px solid #ebebeb !important;
    -webkit-box-sizing: unset;
    -moz-box-sizing: unset;
    box-sizing: unset;
}

.radio-container input.custom-radio:checked + label.circle span.small {
    background-color :skyblue;
}

.checkbox label {
    display: inline-block;
    cursor: pointer;
    position: relative;
    padding-left: 25px;
    margin-right: 15px;
    font-size: 13px;
    padding-bottom: 0;
}

.checkbox label:before {
    content: "";
    display: inline-block;

    width: 20px;
    height: 20px;

    margin-right: 10px;
    position: absolute;
    left: 0;
    bottom: 1px;
    background-color: #fafafa;
    border: 1px solid #e3e3e3 !important;
    border-top: 1px solid #e3e3e3 !important;
    box-shadow: inset 0 1px 2px rgba(0,0,0,.39) !important;
    border-radius: 0 !important;
}

.checkbox input[type=checkbox] {
    display: none;
}

.checkbox label:before {
    border-radius: 3px;
}

.progressbar {
    counter-reset: step;
    padding-bottom: 20px !important;
}

.progressbar li {
    list-style-type: none;
    width: 33%;
    float: left;
    font-size: 12px;
    position: relative;
    text-align: center;
    text-transform: uppercase;
    color: #7d7d7d;
    height: 62px;
    border-bottom: 3px solid #ddd;
}

.progressbar li:after {
    width: 30px;
    height: 30px;
    content: counter(step);
    counter-increment: step;
    line-height: 30px;
    border: 2px solid #ddd;
    color: #ddd;
    background: #ddd;
    display: block;
    text-align: center;
    margin: 10px auto 0 auto;
    border-radius: 50%;
}

.progressbar li:before {
    width: 100%;
    height: 2px;
    content: '';
    position: absolute;
    background-color: #7d7d7d;
    top: 15px;
    left: -50%;
    z-index: -1;
}

.progressbar li:first-child:before {
    content: none;
}

.progressbar li.active:after {
    border-color: rgb(18,100,170);
    background: rgb(18,100,170);
    color: rgb(18,100,170);
}

.progressbar li.active + li:before {
    background-color: #55b776;
}

.progressbar li.completed:after {
    content: "\002714";
    border-color: rgb(18,100,170);
    background: rgb(18,100,170);
    color: #fff;
}

.progressbar li.active {
    border-bottom: 3px solid rgb(18,100,170);
}

input[type=checkbox]:checked + label:before {
    content: "\002714";
    text-shadow: 1px 1px 1px rgba(0, 0, 0, .2);
    font-size: 15px;
    color: #007cba;
    text-align: center;
    line-height: 20px;
}

.erroredInput {
    border: 2px solid #e84c3d !important;
    box-shadow: inset 0 -2px #e84c3d !important;
}

@media only screen and (min-width : 768px) {
    .is-table-row {
        display: table;
    }
    .is-table-row [class*="col-"] {
        float: none;
        display: table-cell;
        vertical-align: top;
    }
}