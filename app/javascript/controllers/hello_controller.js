import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}

let xlsx_all_report = document.getElementById('all_usr_pcl_excel');
let csv_all_report = document.getElementById('all_usr_pcl_csv');

let btn_all_report = document.getElementById('all_usr_pcl_download');

btn_all_report.onclick = all_pcl;

function all_pcl() {
    if(csv_all_report.checked) {
        window.open("/all_counts.csv");
    }else if(xlsx_all_report.checked) {
        window.open("/all_counts.xlsx");
    } else {
        alert("Can't download Nothing!!");
    }
}


let xlsx_report_10pu = document.getElementById('usr_tenp_excel');
let csv_report_10pu = document.getElementById('usr_tenp_csv');

let btn_report_10pu = document.getElementById('usr_tenp_download');

btn_report_10pu.onclick = all_tenpu;

function all_tenpu() {
    if(csv_report_10pu.checked) {
        window.open("/all_limited_tens.csv");
    }else if(xlsx_report_10pu.checked) {
        window.open("/all_limited_tens.xlsx");
    } else {
        alert("Can't download Nothing!!");
    }
}



let xlsx_postwise = document.getElementById('postwise_user_excel');
let csv_postwise = document.getElementById('postwise_user_csv');

let btn_postwise = document.getElementById('postwise_user_btn');

btn_postwise.onclick = all_postwise_dcl;

function all_postwise_dcl() {
    if(csv_postwise.checked) {
        window.open("/all_descripted.csv");
    }else if(xlsx_postwise.checked) {
        window.open("/all_descripted.xlsx");
    } else {
        alert("Can't download Nothing!!");
    }
}
