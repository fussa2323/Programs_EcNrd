#!/usr/bin/perl
use File::Copy;

# CSJのデータコーパスからtestデータ以外を除外して
# LSA計算用にデータを変換するプログラム

#testにつかうfileを除外するための布石
opendir(TEST,"testwav");
@testset = readdir(TEST);
closedir(TEST);

foreach(@testset){
	$_ =~ s/\.wav//;
	$ignore{$_} = 1;
	print "$_\n"
}

#$CSJ = "//Balrog/share/corpus/CSJ";
$CSJ = "../CSJ";

$n = 0;

opendir(CSJ,$CSJ);
@csj = readdir(CSJ);
closedir(CSJ);
foreach(@csj){
	if(/A\d+/s){
		$dir = $_;
		print "$_\n";
		opendir(DIR,"$CSJ/$dir");
		@dir = readdir(DIR);
		closedir(DIR);
		foreach(@dir){
			$subdir = $_;
			if(exists $ignore{$subdir}){
				next;
			}
			#if(int(rand(5)) != 0){
			#	next;
			#}
			$wavname = $subdir.".wav";
			$sdbname = $subdir.".sdb";
			print "$n : $wavname\t$sdbname\n";
			copy("$CSJ/$dir/$subdir/$wavname","train/wav/$wavname");
			copy("$CSJ/$dir/$subdir/$sdbname","train/sdb/$sdbname");
			$n++;
			if($n >= 952){
				exit;
			}
		}
	}
}
