<?php
$app = "rclone";
$appname = "Rclone";
$appversion = "1.42";
$appsite = "https://rclone.org";
$apphelp = "https://rclone.org/docs";

$applogs = array("/tmp/DroboApps/".$app."/log.txt",
                 "/tmp/DroboApps/".$app."/access.log",
                 "/tmp/DroboApps/".$app."/error.log",
                 "/tmp/DroboApps/".$app."/install.log",
                 "/tmp/DroboApps/".$app."/update.log");

$appprotos = array("https");
$appports = array("8040");
$droboip = $_SERVER['SERVER_ADDR'];
$apppage = $appprotos[0]."://".$droboip.":".$appports[0]."/";
$adminpage = $appprotos[0]."://".$droboip.":".$appports[0]."/admin/";
if ($publicip != "") {
  $publicurl = $appprotos[0]."://".$publicip.":".$appports[0]."/";
} else {
  $publicurl = $appprotos[0]."://public.ip.address.here:".$appports[0]."/";
}
$portscansite = "http://mxtoolbox.com/SuperTool.aspx?action=scan%3a".$publicip."&run=toolpage";
?>
