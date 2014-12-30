#!/usr/bin/perl

$sdbdir = "../../DataSet/make_semantic_data/train/sdb";

#���e�L�X�g(�A���t�@�x�b�g���̐��p�ꂪ�����Ă���)�ɑ΂��Ĉȉ������s
open(SM,"../../DataSet/make_semantic_data/senmon.txt");
while(<SM>){
	chomp;
	@yougo = split(/\t/,$_);#Tab��؂��yougo�z��Ɋi�[
	$senmon{$yougo[1]} = 1;
}
close(SM);

opendir(DIR,"$sdbdir");
@file = readdir(DIR);
closedir(DIR);

open("MTM","> ../../Result/make_semantic_result/matome.txt");#�o�̓t�@�C��


foreach(@file){#�S�Ă�sdb�t�@�C���Ɉȉ������s�@
	# unless($_ =~ /sdb/){
	# 	next; #����.sdb����Ȃ���΃��[�v���΂�
	# }
	$sdbfile = $_;#�t�@�C��������

	@bun = ();#�z
	$aflag = 0;
	$oldid = 0;

	print "$sdbfile | ";#�t�@�C�������v�����g

	open(SDB,"$sdbdir/$sdbfile");#�t�@�C�����I�[�v��
	#�I�[�v�������S�Ẵt�@�C���̑S�Ă̍s�Ɉȉ������s
		while(<SDB>){
		@array = split(/\t/,$_);
		if($array[11] ne "����" && $array[11] ne "����" && $array[11] ne "�`�e��"){
			next;#���������`�e���ȊO�̏ꍇ�̓��[�v���΂�
		}
		if($array[7] =~ /�~/){
			next;
		}
		if($array[5] =~ /\(D2.*\)/ || $array[5] =~ /\(\?.*\)/ || $array[5] =~ /\(D.*\)/ || $array[5] =~ /^.*\(D.*\).*/ || $array[5] =~ /\(M.*\)/ || $array[5] =~ /\(O.*\)/ || $array[5] =~ /^.*\(F.*\).*/){
		    next;
		}
		@id = split(/ /,$array[3]);	#�z��id�ɓ]�L�����X�y�[�X��؂�Ŋi�[
		if($id[0] != $oldid && $#bun >= 30){#@id�̐擪�v�f��oldid�łȂ��A
			foreach(@bun){
				$ivword{$_} = 1;
				print MTM "$_\n";
			}
			@bun = ();
			#print MTM "�B\n";
		}
		$oldid = $id[0];#oldid�ɔ��bID����
		if($array[5] =~ /\(O.*\)/ || $array[5] =~ /\(M.*\)/){
			push(@bun,$array[9]);
		}
		if($array[5] =~ /\(A.*\)/){#���K�\����A�^�O�t���̈ꕶ���A���t�@�x�b�g
			@taga = split(/[; ]/,$array[5]);#�ǂ݂ƃA���t�@�x�b�g�𕪂���H
			$taga[2] =~ s/\).*//;#���J�b�R��u�����č폜
			if(exists $senmon{$array[9]}){#��\�`�������ɂ��邩�ǂ����T��
				push(@bun,$array[9]);#bun�z��ɗv�f��ǉ�
			}
			else{
				push(@bun,$array[7]);#��\�`���Ȃ��ꍇ�͒ʏ�̏o���`��ǉ�
			}
			next;#�僋�[�v���X�L�b�v
		}
		if($array[5] =~ /^\(A/){#�s�̍ŏ���A�^�O�������ꍇ
			@taga = split(/ /,$array[5]);
			push(@sors,$array[7]);
			$aflag = 1;#A�t���O�H
			next;
		}
		if($aflag == 1){ #A�t���O���������ꍇ�͍Ō�̕��J�b�R�폜
			if($array[5] =~ /\)/){
				@taga = split(/;/,$array[5]);#;��؂�ŕ�����
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
		if($array[7] eq ""){#�����Ȃ��ꍇ�̓X�L�b�v
			next;
		}
		if($aflag == 0){#���ꂢ�邩�H��
			push(@bun,$array[7]);
		}
	}#while end

	if($#bun >= 0){#�c���bun�ɗ��܂��Ă�P�����o
		foreach(@bun){
			$ivword{$_} = 1;
			print MTM "$_\n";
		}
	}
	#print MTM "�B\n";
	close(SDB);
}
close(MTM);

open(IV,"> ../../Result/make_semantic_result/ivlist.txt");
foreach $key(keys %ivword){
	print IV "$key\n";
}
close(IV);
