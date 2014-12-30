#!/usr/bin/perl

$sdbdir = "../../DataSet/make_semantic_data/train/sdb";

#専門テキスト(アルファベット等の専門用語が入っている)に対して以下を実行
open(SM,"../../DataSet/make_semantic_data/senmon.txt");
while(<SM>){
	chomp;
	@yougo = split(/\t/,$_);#Tab区切りでyougo配列に格納
	$senmon{$yougo[1]} = 1;
}
close(SM);

opendir(DIR,"$sdbdir");
@file = readdir(DIR);
closedir(DIR);

open("MTM","> ../../Result/make_semantic_result/matome.txt");#出力ファイル


foreach(@file){#全てのsdbファイルに以下を実行　
	# unless($_ =~ /sdb/){
	# 	next; #もし.sdbじゃなければループを飛ばす
	# }
	$sdbfile = $_;#ファイル名を代入

	@bun = ();#配
	$aflag = 0;
	$oldid = 0;

	print "$sdbfile | ";#ファイル名をプリント

	open(SDB,"$sdbdir/$sdbfile");#ファイルをオープン
	#オープンした全てのファイルの全ての行に以下を実行
		while(<SDB>){
		@array = split(/\t/,$_);
		if($array[11] ne "名詞" && $array[11] ne "動詞" && $array[11] ne "形容詞"){
			next;#動詞名詞形容詞以外の場合はループを飛ばす
		}
		if($array[7] =~ /×/){
			next;
		}
		if($array[5] =~ /\(D2.*\)/ || $array[5] =~ /\(\?.*\)/ || $array[5] =~ /\(D.*\)/ || $array[5] =~ /^.*\(D.*\).*/ || $array[5] =~ /\(M.*\)/ || $array[5] =~ /\(O.*\)/ || $array[5] =~ /^.*\(F.*\).*/){
		    next;
		}
		@id = split(/ /,$array[3]);	#配列idに転記情報をスペース区切りで格納
		if($id[0] != $oldid && $#bun >= 30){#@idの先頭要素がoldidでなく、
			foreach(@bun){
				$ivword{$_} = 1;
				print MTM "$_\n";
			}
			@bun = ();
			#print MTM "。\n";
		}
		$oldid = $id[0];#oldidに発話IDを代入
		if($array[5] =~ /\(O.*\)/ || $array[5] =~ /\(M.*\)/){
			push(@bun,$array[9]);
		}
		if($array[5] =~ /\(A.*\)/){#正規表現でAタグ付きの一文字アルファベット
			@taga = split(/[; ]/,$array[5]);#読みとアルファベットを分ける？
			$taga[2] =~ s/\).*//;#閉じカッコを置換して削除
			if(exists $senmon{$array[9]}){#代表形が辞書にあるかどうか探す
				push(@bun,$array[9]);#bun配列に要素を追加
			}
			else{
				push(@bun,$array[7]);#代表形がない場合は通常の出現形を追加
			}
			next;#大ループをスキップ
		}
		if($array[5] =~ /^\(A/){#行の最初にAタグが来た場合
			@taga = split(/ /,$array[5]);
			push(@sors,$array[7]);
			$aflag = 1;#Aフラグ？
			next;
		}
		if($aflag == 1){ #Aフラグが立った場合は最後の閉じカッコ削除
			if($array[5] =~ /\)/){
				@taga = split(/;/,$array[5]);#;区切りで分ける
				$taga[1] =~ s/\).*//;
				if(exists $senmon{$taga[1]}){
					push(@bun,$taga[1]);
				}
				else{
					push(@sors,$taga[0]);
					foreach(@sors){
						push(@bun,$_);
					}
				}
				@sors = ();
				$aflag = 0;
			}
			else{
				push(@sors,$array[7]);
			}
			next;
		}
		if($array[7] eq ""){#何もない場合はスキップ
			next;
		}
		if($aflag == 0){#これいるか？笑
			push(@bun,$array[7]);
		}
	}#while end

	if($#bun >= 0){#残りのbunに溜まってる単語を放出
		foreach(@bun){
			$ivword{$_} = 1;
			print MTM "$_\n";
		}
	}
	#print MTM "。\n";
	close(SDB);
}
close(MTM);

open(IV,"> ../../Result/make_semantic_result/ivlist.txt");
foreach $key(keys %ivword){
	print IV "$key\n";
}
close(IV);
