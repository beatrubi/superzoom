#!/usr/bin/perl
#
# Display the picture of the day
#
# Version 1.0.0 (C) 9.2024 by Beat Rubischon <beat@0x1b.ch>
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
use strict;
use warnings;
use Cwd qw(cwd);
use File::Copy;

my $debug=1;
my $today;

#
# mapping
my %pic=(
  "0101" => "7N9A0288.jpeg",
  "0102" => "7N9A0293.jpeg",
  "0103" => "7N9A0305.jpeg",
  "0104" => "7N9A0311.jpeg",
  "0105" => "7N9A0315.jpeg",
  "0106" => "7N9A0322.jpeg",
  "0107" => "7N9A0330.jpeg",
  "0108" => "7N9A0339.jpeg",
  "0109" => "7N9A0342.jpeg",
  "0110" => "7N9A0347.jpeg",
  "0111" => "7N9A0350.jpeg",
  "0112" => "7N9A0353.jpeg",
  "0113" => "7N9A0358.jpeg",
  "0114" => "7N9A0360.jpeg",
  "0115" => "7N9A0363.jpeg",
  "0116" => "7N9A0368.jpeg",
  "0117" => "7N9A0371.jpeg",
  "0118" => "7N9A0378.jpeg",
  "0119" => "7N9A0381.jpeg",
  "0120" => "7N9A0410.jpeg",
  "0121" => "7N9A0413.jpeg",
  "0122" => "7N9A0426.jpeg",
  "0123" => "7N9A0431.jpeg",
  "0124" => "7N9A0546.jpeg",
  "0125" => "7N9A0547.jpeg",
  "0126" => "7N9A0552.jpeg",
  "0127" => "7N9A0556.jpeg",
  "0128" => "7N9A0559.jpeg",
  "0129" => "7N9A0738.jpeg",
  "0130" => "7N9A0743.jpeg",
  "0131" => "7N9A0938.jpeg",
  "0201" => "7N9A0943.jpeg",
  "0202" => "7N9A0949.jpeg",
  "0203" => "7N9A0957.jpeg",
  "0204" => "7N9A1170.jpeg",
  "0205" => "7N9A1172.jpeg",
  "0206" => "7N9A1186.jpeg",
  "0207" => "7N9A1194.jpeg",
  "0208" => "7N9A1205.jpeg",
  "0209" => "7N9A1229.jpeg",
  "0210" => "7N9A1238.jpeg",
  "0211" => "7N9A1240.jpeg",
  "0212" => "7N9A1249.jpeg",
  "0213" => "7N9A1261.jpeg",
  "0214" => "7N9A1270.jpeg",
  "0215" => "7N9A1273.jpeg",
  "0216" => "7N9A1275.jpeg",
  "0217" => "7N9A1286.jpeg",
  "0218" => "7N9A1310.jpeg",
  "0219" => "7N9A1312.jpeg",
  "0220" => "7N9A1315.jpeg",
  "0221" => "7N9A1323.jpeg",
  "0222" => "7N9A1329.jpeg",
  "0223" => "7N9A1343.jpeg",
  "0224" => "7N9A1345.jpeg",
  "0225" => "7N9A1356.jpeg",
  "0226" => "7N9A1375.jpeg",
  "0227" => "7N9A1380.jpeg",
  "0228" => "7N9A1390.jpeg",
  "0229" => "7N9A1400.jpeg",
  "0301" => "7N9A1425.jpeg",
  "0302" => "7N9A1429.jpeg",
  "0303" => "7N9A1435.jpeg",
  "0304" => "7N9A1447.jpeg",
  "0305" => "7N9A1449.jpeg",
  "0306" => "7N9A1456.jpeg",
  "0307" => "7N9A1459.jpeg",
  "0308" => "7N9A1463.jpeg",
  "0309" => "7N9A1466.jpeg",
  "0310" => "7N9A2042.jpeg",
  "0311" => "7N9A2054.jpeg",
  "0312" => "7N9A2056.jpeg",
  "0313" => "7N9A2059.jpeg",
  "0314" => "7N9A2063.jpeg",
  "0315" => "7N9A2067.jpeg",
  "0316" => "7N9A2075.jpeg",
  "0317" => "7N9A2078.jpeg",
  "0318" => "7N9A2084.jpeg",
  "0319" => "7N9A2090.jpeg",
  "0320" => "7N9A2100.jpeg",
  "0321" => "7N9A2110.jpeg",
  "0322" => "7N9A2119.jpeg",
  "0323" => "7N9A2134.jpeg",
  "0324" => "7N9A2158.jpeg",
  "0325" => "7N9A2174.jpeg",
  "0326" => "7N9A2177.jpeg",
  "0327" => "7N9A2180.jpeg",
  "0328" => "7N9A2188.jpeg",
  "0329" => "7N9A2454.jpeg",
  "0330" => "7N9A2476.jpeg",
  "0331" => "7N9A2989.jpeg",
  "0401" => "7N9A3025.jpeg",
  "0402" => "7N9A3031.jpeg",
  "0403" => "7N9A3043.jpeg",
  "0404" => "7N9A3053.jpeg",
  "0405" => "7N9A3077.jpeg",
  "0406" => "7N9A3081.jpeg",
  "0407" => "7N9A3106.jpeg",
  "0408" => "7N9A3112.jpeg",
  "0409" => "7N9A3122.jpeg",
  "0410" => "7N9A3130.jpeg",
  "0411" => "7N9A3142.jpeg",
  "0412" => "7N9A3145.jpeg",
  "0413" => "7N9A3152.jpeg",
  "0414" => "7N9A3160.jpeg",
  "0415" => "7N9A3193.jpeg",
  "0416" => "7N9A3196.jpeg",
  "0417" => "7N9A3199.jpeg",
  "0418" => "7N9A3240.jpeg",
  "0419" => "7N9A3247.jpeg",
  "0420" => "7N9A3386.jpeg",
  "0421" => "7N9A3735.jpeg",
  "0422" => "7N9A3741.jpeg",
  "0423" => "7N9A3755.jpeg",
  "0424" => "7N9A3795.jpeg",
  "0425" => "7N9A3833.jpeg",
  "0426" => "7N9A3835.jpeg",
  "0427" => "7N9A3840.jpeg",
  "0428" => "7N9A3854.jpeg",
  "0429" => "7N9A3898.jpeg",
  "0430" => "7N9A3908.jpeg",
  "0501" => "7N9A3911.jpeg",
  "0502" => "7N9A3917.jpeg",
  "0503" => "7N9A3930.jpeg",
  "0504" => "7N9A3942.jpeg",
  "0505" => "7N9A3948.jpeg",
  "0506" => "7N9A3965.jpeg",
  "0507" => "7N9A3966.jpeg",
  "0508" => "7N9A3972.jpeg",
  "0509" => "7N9A4250.jpeg",
  "0510" => "7N9A4260.jpeg",
  "0511" => "7N9A4263.jpeg",
  "0512" => "7N9A4967.jpeg",
  "0513" => "7N9A4970.jpeg",
  "0514" => "7N9A4971.jpeg",
  "0515" => "7N9A4974.jpeg",
  "0516" => "7N9A4982.jpeg",
  "0517" => "7N9A4988.jpeg",
  "0518" => "7N9A4989.jpeg",
  "0519" => "7N9A4996.jpeg",
  "0520" => "7N9A5010.jpeg",
  "0521" => "7N9A5022.jpeg",
  "0522" => "7N9A5038.jpeg",
  "0523" => "7N9A5104.jpeg",
  "0524" => "7N9A5115.jpeg",
  "0525" => "7N9A5118.jpeg",
  "0526" => "7N9A5362.jpeg",
  "0527" => "7N9A5363.jpeg",
  "0528" => "7N9A5378.jpeg",
  "0529" => "7N9A5380.jpeg",
  "0530" => "7N9A5386.jpeg",
  "0531" => "7N9A5392.jpeg",
  "0601" => "7N9A5394.jpeg",
  "0602" => "7N9A5406.jpeg",
  "0603" => "7N9A5692.jpeg",
  "0604" => "7N9A5708.jpeg",
  "0605" => "7N9A5711.jpeg",
  "0606" => "7N9A5719.jpeg",
  "0607" => "7N9A5817.jpeg",
  "0608" => "7N9A5828.jpeg",
  "0609" => "7N9A5844.jpeg",
  "0610" => "7N9A5852.jpeg",
  "0611" => "7N9A5856.jpeg",
  "0612" => "7N9A5867.jpeg",
  "0613" => "7N9A5879.jpeg",
  "0614" => "7N9A5881.jpeg",
  "0615" => "7N9A5893.jpeg",
  "0616" => "7N9A5905.jpeg",
  "0617" => "7N9A5918.jpeg",
  "0618" => "7N9A5922.jpeg",
  "0619" => "7N9A5940.jpeg",
  "0620" => "7N9A5952.jpeg",
  "0621" => "7N9A5966.jpeg",
  "0622" => "7N9A6175.jpeg",
  "0623" => "7N9A6413.jpeg",
  "0624" => "7N9A6428.jpeg",
  "0625" => "7N9A6437.jpeg",
  "0626" => "7N9A6441.jpeg",
  "0627" => "7N9A6471.jpeg",
  "0628" => "7N9A6481.jpeg",
  "0629" => "7N9A6491.jpeg",
  "0630" => "7N9A6511.jpeg",
  "0701" => "7N9A6513.jpeg",
  "0702" => "7N9A6519.jpeg",
  "0703" => "7N9A6574.jpeg",
  "0704" => "7N9A6588.jpeg",
  "0705" => "7N9A6617.jpeg",
  "0706" => "7N9A6619.jpeg",
  "0707" => "7N9A6624.jpeg",
  "0708" => "7N9A6629.jpeg",
  "0709" => "7N9A6632.jpeg",
  "0710" => "7N9A6642.jpeg",
  "0711" => "7N9A6659.jpeg",
  "0712" => "7N9A6672.jpeg",
  "0713" => "7N9A6692.jpeg",
  "0714" => "7N9A6695.jpeg",
  "0715" => "7N9A6704.jpeg",
  "0716" => "7N9A6709.jpeg",
  "0717" => "7N9A6712.jpeg",
  "0718" => "7N9A6721.jpeg",
  "0719" => "7N9A6728.jpeg",
  "0720" => "7N9A6755.jpeg",
  "0721" => "7N9A6759.jpeg",
  "0722" => "7N9A6761.jpeg",
  "0723" => "7N9A6766.jpeg",
  "0724" => "7N9A6771.jpeg",
  "0725" => "7N9A6775.jpeg",
  "0726" => "7N9A6777.jpeg",
  "0727" => "7N9A6797.jpeg",
  "0728" => "7N9A6804.jpeg",
  "0729" => "7N9A6857.jpeg",
  "0730" => "7N9A6864.jpeg",
  "0731" => "7N9A6867.jpeg",
  "0801" => "7N9A6942.jpeg",
  "0802" => "7N9A7362.jpeg",
  "0803" => "7N9A7515.jpeg",
  "0804" => "7N9A7621.jpeg",
  "0805" => "7N9A7622.jpeg",
  "0806" => "7N9A7632.jpeg",
  "0807" => "7N9A7635.jpeg",
  "0808" => "7N9A7643.jpeg",
  "0809" => "7N9A7660.jpeg",
  "0810" => "7N9A7663.jpeg",
  "0811" => "7N9A7664.jpeg",
  "0812" => "7N9A7672.jpeg",
  "0813" => "7N9A7680.jpeg",
  "0814" => "7N9A7685.jpeg",
  "0815" => "7N9A7694.jpeg",
  "0816" => "7N9A7699.jpeg",
  "0817" => "7N9A7714.jpeg",
  "0818" => "7N9A7723.jpeg",
  "0819" => "7N9A7726.jpeg",
  "0820" => "7N9A7728.jpeg",
  "0821" => "7N9A7748.jpeg",
  "0822" => "7N9A7756.jpeg",
  "0823" => "7N9A7771.jpeg",
  "0824" => "7N9A7781.jpeg",
  "0825" => "7N9A8042.jpeg",
  "0826" => "7N9A8047.jpeg",
  "0827" => "7N9A8053-1.jpeg", # duplicate filename with 4.11.23
  "0828" => "7N9A8072.jpeg",
  "0829" => "7N9A8074.jpeg",
  "0830" => "7N9A8083.jpeg",
  "0831" => "7N9A8088.jpeg",
  "0901" => "7N9A8093.jpeg",
  "0902" => "7N9A8100.jpeg",
  "0903" => "7N9A8127.jpeg",
  "0904" => "7N9A8134-1.jpeg", # duplicate filename with 16.11.23
  "0905" => "7N9A8138-1.jpeg", # duplicate filename with 18.11.23
  "0906" => "7N9A8149.jpeg",
  "0907" => "7N9A8156.jpeg",
  "0908" => "7N9A8161.jpeg",
  "0909" => "7N9A8165.jpeg",
  "0910" => "7N9A8168.jpeg",
  "0911" => "7N9A8169.jpeg",
  "0912" => "7N9A8185.jpeg",
  "0913" => "7N9A8187.jpeg",
  "0914" => "7N9A8197.jpeg",
  "0915" => "7N9A8220-1.jpeg",  # duplicate filename with 24.11.23
  "0916" => "7N9A8226.jpeg",
  "0917" => "7N9A8239.jpeg",
  "0918" => "7N9A8245.jpeg",
  "0919" => "7N9A8256.jpeg",
  "0920" => "7N9A8260.jpeg",
  "0921" => "7N9A8266.jpeg",
  "0922" => "7N9A8269.jpeg",
  "0923" => "7N9A8278.jpeg",
  "0924" => "7N9A8289.jpeg",
  "0925" => "7N9A8298.jpeg",
  "0926" => "7N9A8301.jpeg",
  "0927" => "7N9A8307.jpeg",
  "0928" => "7N9A8311.jpeg",
  "0929" => "7N9A8330.jpeg",
  "0930" => "7N9A8347.jpeg",
  "1001" => "7N9A6739.jpeg",
  "1002" => "7N9A6741.jpeg",
  "1003" => "7N9A6744.jpeg",
  "1004" => "7N9A6762.jpeg",
  "1005" => "7N9A6773.jpeg",
  "1006" => "7N9A6805.jpeg",
  "1007" => "7N9A6807.jpeg",
  "1008" => "7N9A6836.jpeg",
  "1009" => "7N9A6983.jpeg",
  "1010" => "7N9A6994.jpeg",
  "1011" => "7N9A6997.jpeg",
  "1012" => "7N9A7003.jpeg",
  "1013" => "7N9A7014.jpeg",
  "1014" => "7N9A7021.jpeg",
  "1015" => "7N9A7030.jpeg",
  "1016" => "7N9A7053.jpeg",
  "1017" => "7N9A7066.jpeg",
  "1018" => "7N9A7072.jpeg",
  "1019" => "7N9A7076.jpeg",
  "1020" => "7N9A7102.jpeg",
  "1021" => "7N9A7118.jpeg",
  "1022" => "7N9A7125.jpeg",
  "1023" => "7N9A7131.jpeg",
  "1024" => "7N9A7162.jpeg",
  "1025" => "7N9A7173.jpeg",
  "1026" => "7N9A7184.jpeg",
  "1027" => "7N9A7187.jpeg",
  "1028" => "7N9A7198.jpeg",
  "1029" => "7N9A7261.jpeg",
  "1030" => "7N9A7583.jpeg",
  "1031" => "7N9A7968.jpeg",
  "1101" => "7N9A7978.jpeg",
  "1102" => "7N9A7983.jpeg",
  "1103" => "7N9A8002.jpeg",
  "1104" => "7N9A8053.jpeg", # duplicate filename with 27.8.24
  "1105" => "7N9A8056.jpeg",
  "1106" => "7N9A8060.jpeg",
  "1107" => "7N9A8064.jpeg",
  "1108" => "7N9A8067.jpeg",
  "1109" => "7N9A8076.jpeg",
  "1110" => "7N9A8086.jpeg",
  "1111" => "7N9A8095.jpeg",
  "1112" => "7N9A8103.jpeg",
  "1113" => "7N9A8106.jpeg",
  "1114" => "7N9A8107.jpeg",
  "1115" => "7N9A8119.jpeg",
  "1116" => "7N9A8134.jpeg", # duplicate filename with 4.9.24
  "1117" => "7N9A8138.jpeg", # dated 2023:11:18 01:27:16.88+01:00, duplicate filename with 5.9.24
  "1118" => "7N9A8159.jpeg",
  "1119" => "7N9A8162.jpeg",
  "1120" => "7N9A8166.jpeg",
  "1121" => "7N9A8188.jpeg",
  "1122" => "7N9A8206.jpeg",
  "1123" => "7N9A8216.jpeg",
  "1124" => "7N9A8220.jpeg", # duplicate filename with 15.9.24
  "1125" => "7N9A8235.jpeg",
  "1126" => "7N9A8237.jpeg",
  "1127" => "7N9A8308.jpeg",
  "1128" => "7N9A8312.jpeg",
  "1129" => "7N9A8326.jpeg",
  "1130" => "7N9A8332.jpeg",
  "1201" => "7N9A8338.jpeg",
  "1202" => "7N9A8344.jpeg",
  "1203" => "7N9A8351.jpeg",
  "1204" => "7N9A8360.jpeg",
  "1205" => "7N9A8385.jpeg",
  "1206" => "7N9A8442.jpeg",
  "1207" => "7N9A8447.jpeg",
  "1208" => "7N9A8454.jpeg",
  "1209" => "7N9A8455.jpeg",
  "1210" => "7N9A8473.jpeg",
  "1211" => "7N9A8484.jpeg",
  "1212" => "7N9A8511.jpeg",
  "1213" => "7N9A8551.jpeg",
  "1214" => "7N9A8571.jpeg",
  "1215" => "7N9A8607.jpeg",
  "1216" => "7N9A8617.jpeg",
  "1217" => "7N9A8693.jpeg",
  "1218" => "7N9A8698.jpeg",
  "1219" => "7N9A8721.jpeg",
  "1220" => "7N9A8726.jpeg",
  "1221" => "7N9A8733.jpeg",
  "1222" => "7N9A8740.jpeg",
  "1223" => "7N9A8741.jpeg",
  "1224" => "7N9A8838.jpeg",
  "1225" => "7N9A0242.jpeg",
  "1226" => "7N9A0251.jpeg",
  "1227" => "7N9A0255.jpeg",
  "1228" => "7N9A0271.jpeg",
  "1229" => "7N9A0276.jpeg",
  "1230" => "7N9A0278.jpeg",
  "1231" => "7N9A0284.jpeg",
);

#
# open debug log
if ($debug) {
  open LOG, ">".$ENV{'HOME'}."/Library/Logs/Superzoom.log";
  select LOG;
  $|=1;
  select STDOUT;
}

#
# fork off sleepwatcher
my $pid=open WATCH, "-|";
if ($pid == 0) {
  exec cwd()."/sleepwatcher", "-w", "/bin/echo";
  exit;
}

#
# main loop
while(1) {

  # get current time
  my $now=time;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime($now);

  if ($debug) {
    print LOG "now: ".scalar localtime($now);
  }

  # check if we have a new day
  if (! defined $today or $today < $yday or $today != 0 and $yday == 0) {
    $today=$yday;
    my $mmdd=sprintf "%02i%02i", $mon+1, $mday;
    if ($debug) {
      print LOG ", image: $mmdd";
    }
    unlink $ENV{'HOME'}."/Pictures/Wallpaper.jpeg";
#    symlink cwd()."/Pictures/".$pic{$mmdd},
#      $ENV{'HOME'}."/Pictures/Wallpaper.jpeg";
    copy(cwd()."/Pictures/".$pic{$mmdd},
      $ENV{'HOME'}."/Pictures/Wallpaper.jpeg");
    system "killall Dock";
  }

  # take a nap until tomorrow
  my $sleep=(23-$hour)*3600 + (59-$min)*60 + (59-$sec) + 2;
  if ($debug) {
    print LOG ", next: ".scalar localtime($now + $sleep)."\n";
  }

  # sleep and listen to sleepwatcher
  my $rin="";
  my $rout;
  vec($rin,fileno(WATCH),1) = 1;
  if (select($rout=$rin, undef, undef, $sleep)) {
    my $byte;
    sysread(WATCH, $byte, 1);
    if ($debug) {
      print LOG "...returned from suspend...\n";
      sleep(5);
    }
  }
}
