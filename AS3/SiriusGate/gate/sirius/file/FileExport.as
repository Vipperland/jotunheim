﻿/**
 *
 * 		FileExport.bitmap //Export a image fileom BitmapData [JPG-PNG]
 * 		FileExport.movie //Export a image fileom MovieClip [JPG-PNG]
 * 		FileExport.dataFile //Export a text document file String [TXT, XML, ...]
 *
 * 		--------------------------------------------------
 *
 *		Original files from CoreLib:
 *		JPGEncoder.as
 *		PNGEncoder.as
 *		BitString.as
 *
 *		Copyright (c) 2008, Adobe Systems Incorporated
 *		All rights reserved.
 *
 *		Redistribution and use in source and binary forms, with or without
 *		modification, are permitted provided that the following conditions are
 *		met:
 *
 *		- Redistributions of source code must retain the above copyright notice,
 *		this list of conditions and the following disclaimer.
 *
 *		 Redistributions in binary form must reproduce the above copyright
 *		notice, this list of conditions and the following disclaimer in the
 *		documentation and/or other materials provided with the distribution.
 *
 *		- Neither the name of Adobe Systems Incorporated nor the names of its
 *		contributors may be used to endorse or promote products derived fileom
 *		this software without specific prior written permission.
 *
 *		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 *		IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 *		THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 *		PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 *		CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *		EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 *		PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *		PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *		LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *		NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *		SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

package gate.sirius.file {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	
	/**
	 * Permite salvar o conteúdo do flash como arquivo de texto ou imagem
	 */
	public class FileExport {
		
		/** @private */
		private var ZigZag:Array = [0, 1, 5, 6, 14, 15, 27, 28, 2, 4, 7, 13, 16, 26, 29, 42, 3, 8, 12, 17, 25, 30, 41, 43, 9, 11, 18, 24, 31, 40, 44, 53, 10, 19, 23, 32, 39, 45, 52, 54, 20, 22, 33, 38, 46,
			51, 55, 60, 21, 34, 37, 47, 50, 56, 59, 61, 35, 36, 48, 49, 57, 58, 62, 63];
		
		/** @private */
		private var YTable:Array = new Array(64);
		
		/** @private */
		private var UVTable:Array = new Array(64);
		
		/** @private */
		private var fdtbl_Y:Array = new Array(64);
		
		/** @private */
		private var fdtbl_UV:Array = new Array(64);
		
		
		/** @private */
		private function initQuantTables(sf:int):void {
			var i:int;
			var t:Number;
			var YQT:Array = [16, 11, 10, 16, 24, 40, 51, 61, 12, 12, 14, 19, 26, 58, 60, 55, 14, 13, 16, 24, 40, 57, 69, 56, 14, 17, 22, 29, 51, 87, 80, 62, 18, 22, 37, 56, 68, 109, 103, 77, 24, 35, 55, 64,
				81, 104, 113, 92, 49, 64, 78, 87, 103, 121, 120, 101, 72, 92, 95, 98, 112, 100, 103, 99];
			for (i = 0; i < 64; i++) {
				t = Math.floor((YQT[i] * sf + 50) / 100);
				if (t < 1) {
					t = 1;
				} else if (t > 255) {
					t = 255;
				}
				YTable[ZigZag[i]] = t;
			}
			var UVQT:Array = [17, 18, 24, 47, 99, 99, 99, 99, 18, 21, 26, 66, 99, 99, 99, 99, 24, 26, 56, 99, 99, 99, 99, 99, 47, 66, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
				99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99];
			for (i = 0; i < 64; i++) {
				t = Math.floor((UVQT[i] * sf + 50) / 100);
				if (t < 1) {
					t = 1;
				} else if (t > 255) {
					t = 255;
				}
				UVTable[ZigZag[i]] = t;
			}
			var aasf:Array = [1.0, 1.387039845, 1.306562965, 1.175875602, 1.0, 0.785694958, 0.541196100, 0.275899379];
			i = 0;
			for (var row:int = 0; row < 8; row++) {
				for (var col:int = 0; col < 8; col++) {
					fdtbl_Y[i] = (1.0 / (YTable[ZigZag[i]] * aasf[row] * aasf[col] * 8.0));
					fdtbl_UV[i] = (1.0 / (UVTable[ZigZag[i]] * aasf[row] * aasf[col] * 8.0));
					i++;
				}
			}
		}
		
		/** @private */
		private var YDC_HT:Array;
		
		/** @private */
		private var UVDC_HT:Array;
		
		/** @private */
		private var YAC_HT:Array;
		
		/** @private */
		private var UVAC_HT:Array;
		
		
		/** @private */
		private function computeHuffmanTbl(nrcodes:Array, std_table:Array):Array {
			var codevalue:int = 0;
			var pos_in_table:int = 0;
			var HT:Array = new Array();
			for (var k:int = 1; k <= 16; k++) {
				for (var j:int = 1; j <= nrcodes[k]; j++) {
					HT[std_table[pos_in_table]] = new BitString();
					HT[std_table[pos_in_table]].val = codevalue;
					HT[std_table[pos_in_table]].len = k;
					pos_in_table++;
					codevalue++;
				}
				codevalue *= 2;
			}
			return HT;
		}
		
		/** @private */
		private var std_dc_luminance_nrcodes:Array = [0, 0, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0];
		
		/** @private */
		private var std_dc_luminance_values:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
		
		/** @private */
		private var std_ac_luminance_nrcodes:Array = [0, 0, 2, 1, 3, 3, 2, 4, 3, 5, 5, 4, 4, 0, 0, 1, 0x7d];
		
		/** @private */
		private var std_ac_luminance_values:Array = [0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12, 0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07, 0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08, 0x23,
			0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0, 0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a,
			0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7a,
			0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7,
			0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea, 0xf1,
			0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa];
		
		/** @private */
		private var std_dc_chrominance_nrcodes:Array = [0, 0, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0];
		
		/** @private */
		private var std_dc_chrominance_values:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
		
		/** @private */
		private var std_ac_chrominance_nrcodes:Array = [0, 0, 2, 1, 2, 4, 4, 3, 4, 7, 5, 4, 4, 0, 1, 2, 0x77];
		
		/** @private */
		private var std_ac_chrominance_values:Array = [0x00, 0x01, 0x02, 0x03, 0x11, 0x04, 0x05, 0x21, 0x31, 0x06, 0x12, 0x41, 0x51, 0x07, 0x61, 0x71, 0x13, 0x22, 0x32, 0x81, 0x08, 0x14, 0x42, 0x91, 0xa1,
			0xb1, 0xc1, 0x09, 0x23, 0x33, 0x52, 0xf0, 0x15, 0x62, 0x72, 0xd1, 0x0a, 0x16, 0x24, 0x34, 0xe1, 0x25, 0xf1, 0x17, 0x18, 0x19, 0x1a, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x35, 0x36, 0x37, 0x38, 0x39,
			0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
			0x7a, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5,
			0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
			0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa];
		
		
		/** @private */
		private function initHuffmanTbl():void {
			YDC_HT = computeHuffmanTbl(std_dc_luminance_nrcodes, std_dc_luminance_values);
			UVDC_HT = computeHuffmanTbl(std_dc_chrominance_nrcodes, std_dc_chrominance_values);
			YAC_HT = computeHuffmanTbl(std_ac_luminance_nrcodes, std_ac_luminance_values);
			UVAC_HT = computeHuffmanTbl(std_ac_chrominance_nrcodes, std_ac_chrominance_values);
		}
		
		/** @private */
		private var bitcode:Array = new Array(65535);
		
		/** @private */
		private var category:Array = new Array(65535);
		
		
		/** @private */
		private function initCategoryNumber():void {
			var nrlower:int = 1;
			var nrupper:int = 2;
			var nr:int;
			for (var cat:int = 1; cat <= 15; cat++) {
				for (nr = nrlower; nr < nrupper; nr++) {
					category[32767 + nr] = cat;
					bitcode[32767 + nr] = new BitString();
					bitcode[32767 + nr].len = cat;
					bitcode[32767 + nr].val = nr;
				}
				for (nr = -(nrupper - 1); nr <= -nrlower; nr++) {
					category[32767 + nr] = cat;
					bitcode[32767 + nr] = new BitString();
					bitcode[32767 + nr].len = cat;
					bitcode[32767 + nr].val = nrupper - 1 + nr;
				}
				nrlower <<= 1;
				nrupper <<= 1;
			}
		}
		
		/** @private */
		private var byteout:ByteArray;
		
		/** @private */
		private var bytenew:int = 0;
		
		/** @private */
		private var bytepos:int = 7;
		
		
		/** @private */
		private function writeBits(bs:BitString):void {
			var value:int = bs.val;
			var posval:int = bs.len - 1;
			while (posval >= 0) {
				if (value & uint(1 << posval)) {
					bytenew |= uint(1 << bytepos);
				}
				posval--;
				bytepos--;
				if (bytepos < 0) {
					if (bytenew == 0xFF) {
						writeByte(0xFF);
						writeByte(0);
					} else {
						writeByte(bytenew);
					}
					bytepos = 7;
					bytenew = 0;
				}
			}
		}
		
		
		/** @private */
		private function writeByte(value:int):void {
			byteout.writeByte(value);
		}
		
		
		/** @private */
		private function writeWord(value:int):void {
			writeByte((value >> 8) & 0xFF);
			writeByte((value) & 0xFF);
		}
		
		
		/** @private */
		private function fDCTQuant(data:Array, fdtbl:Array):Array {
			var tmp0:Number, tmp1:Number, tmp2:Number, tmp3:Number, tmp4:Number, tmp5:Number, tmp6:Number, tmp7:Number;
			var tmp10:Number, tmp11:Number, tmp12:Number, tmp13:Number;
			var z1:Number, z2:Number, z3:Number, z4:Number, z5:Number, z11:Number, z13:Number;
			var i:int;
			var dataOff:int = 0;
			for (i = 0; i < 8; i++) {
				tmp0 = data[dataOff + 0] + data[dataOff + 7];
				tmp7 = data[dataOff + 0] - data[dataOff + 7];
				tmp1 = data[dataOff + 1] + data[dataOff + 6];
				tmp6 = data[dataOff + 1] - data[dataOff + 6];
				tmp2 = data[dataOff + 2] + data[dataOff + 5];
				tmp5 = data[dataOff + 2] - data[dataOff + 5];
				tmp3 = data[dataOff + 3] + data[dataOff + 4];
				tmp4 = data[dataOff + 3] - data[dataOff + 4];
				
				tmp10 = tmp0 + tmp3;
				tmp13 = tmp0 - tmp3;
				tmp11 = tmp1 + tmp2;
				tmp12 = tmp1 - tmp2;
				
				data[dataOff + 0] = tmp10 + tmp11;
				data[dataOff + 4] = tmp10 - tmp11;
				
				z1 = (tmp12 + tmp13) * 0.707106781;
				data[dataOff + 2] = tmp13 + z1;
				data[dataOff + 6] = tmp13 - z1;
				
				tmp10 = tmp4 + tmp5;
				tmp11 = tmp5 + tmp6;
				tmp12 = tmp6 + tmp7;
				
				z5 = (tmp10 - tmp12) * 0.382683433;
				z2 = 0.541196100 * tmp10 + z5;
				z4 = 1.306562965 * tmp12 + z5;
				z3 = tmp11 * 0.707106781;
				
				z11 = tmp7 + z3;
				z13 = tmp7 - z3;
				
				data[dataOff + 5] = z13 + z2;
				data[dataOff + 3] = z13 - z2;
				data[dataOff + 1] = z11 + z4;
				data[dataOff + 7] = z11 - z4;
				
				dataOff += 8;
			}
			
			dataOff = 0;
			for (i = 0; i < 8; i++) {
				tmp0 = data[dataOff + 0] + data[dataOff + 56];
				tmp7 = data[dataOff + 0] - data[dataOff + 56];
				tmp1 = data[dataOff + 8] + data[dataOff + 48];
				tmp6 = data[dataOff + 8] - data[dataOff + 48];
				tmp2 = data[dataOff + 16] + data[dataOff + 40];
				tmp5 = data[dataOff + 16] - data[dataOff + 40];
				tmp3 = data[dataOff + 24] + data[dataOff + 32];
				tmp4 = data[dataOff + 24] - data[dataOff + 32];
				
				tmp10 = tmp0 + tmp3;
				tmp13 = tmp0 - tmp3;
				tmp11 = tmp1 + tmp2;
				tmp12 = tmp1 - tmp2;
				
				data[dataOff + 0] = tmp10 + tmp11;
				data[dataOff + 32] = tmp10 - tmp11;
				
				z1 = (tmp12 + tmp13) * 0.707106781;
				data[dataOff + 16] = tmp13 + z1;
				data[dataOff + 48] = tmp13 - z1;
				
				tmp10 = tmp4 + tmp5;
				tmp11 = tmp5 + tmp6;
				tmp12 = tmp6 + tmp7;
				
				z5 = (tmp10 - tmp12) * 0.382683433;
				z2 = 0.541196100 * tmp10 + z5;
				z4 = 1.306562965 * tmp12 + z5;
				z3 = tmp11 * 0.707106781;
				
				z11 = tmp7 + z3;
				z13 = tmp7 - z3;
				
				data[dataOff + 40] = z13 + z2;
				data[dataOff + 24] = z13 - z2;
				data[dataOff + 8] = z11 + z4;
				data[dataOff + 56] = z11 - z4;
				
				dataOff++;
			}
			
			for (i = 0; i < 64; i++) {
				data[i] = Math.round((data[i] * fdtbl[i]));
			}
			return data;
		}
		
		
		/** @private */
		private function writeAPP0():void {
			writeWord(0xFFE0);
			writeWord(16);
			writeByte(0x4A);
			writeByte(0x46);
			writeByte(0x49);
			writeByte(0x46);
			writeByte(0);
			writeByte(1);
			writeByte(1);
			writeByte(0);
			writeWord(1);
			writeWord(1);
			writeByte(0);
			writeByte(0);
		}
		
		
		/** @private */
		private function writeSOF0(width:int, height:int):void {
			writeWord(0xFFC0);
			writeWord(17);
			writeByte(8);
			writeWord(height);
			writeWord(width);
			writeByte(3);
			writeByte(1);
			writeByte(0x11);
			writeByte(0);
			writeByte(2);
			writeByte(0x11);
			writeByte(1);
			writeByte(3);
			writeByte(0x11);
			writeByte(1);
		}
		
		
		/** @private */
		private function writeDQT():void {
			writeWord(0xFFDB);
			writeWord(132);
			writeByte(0);
			var i:int;
			for (i = 0; i < 64; i++) {
				writeByte(YTable[i]);
			}
			writeByte(1);
			for (i = 0; i < 64; i++) {
				writeByte(UVTable[i]);
			}
		}
		
		
		/** @private */
		private function writeDHT():void {
			writeWord(0xFFC4);
			writeWord(0x01A2);
			var i:int;
			
			writeByte(0);
			for (i = 0; i < 16; i++) {
				writeByte(std_dc_luminance_nrcodes[i + 1]);
			}
			for (i = 0; i <= 11; i++) {
				writeByte(std_dc_luminance_values[i]);
			}
			
			writeByte(0x10);
			for (i = 0; i < 16; i++) {
				writeByte(std_ac_luminance_nrcodes[i + 1]);
			}
			for (i = 0; i <= 161; i++) {
				writeByte(std_ac_luminance_values[i]);
			}
			
			writeByte(1);
			for (i = 0; i < 16; i++) {
				writeByte(std_dc_chrominance_nrcodes[i + 1]);
			}
			for (i = 0; i <= 11; i++) {
				writeByte(std_dc_chrominance_values[i]);
			}
			
			writeByte(0x11);
			for (i = 0; i < 16; i++) {
				writeByte(std_ac_chrominance_nrcodes[i + 1]);
			}
			for (i = 0; i <= 161; i++) {
				writeByte(std_ac_chrominance_values[i]);
			}
		}
		
		
		/** @private */
		private function writeSOS():void {
			writeWord(0xFFDA);
			writeWord(12);
			writeByte(3);
			writeByte(1);
			writeByte(0);
			writeByte(2);
			writeByte(0x11);
			writeByte(3);
			writeByte(0x11);
			writeByte(0);
			writeByte(0x3f);
			writeByte(0);
		}
		
		/** @private */
		private var DU:Array = new Array(64);
		
		
		/** @private */
		private function processDU(CDU:Array, fdtbl:Array, DC:Number, HTDC:Array, HTAC:Array):Number {
			var EOB:BitString = HTAC[0x00];
			var M16zeroes:BitString = HTAC[0xF0];
			var i:int;
			
			var DU_DCT:Array = fDCTQuant(CDU, fdtbl);
			
			for (i = 0; i < 64; i++) {
				DU[ZigZag[i]] = DU_DCT[i];
			}
			var Diff:int = DU[0] - DC;
			DC = DU[0];
			
			if (Diff == 0) {
				writeBits(HTDC[0]);
			} else {
				writeBits(HTDC[category[32767 + Diff]]);
				writeBits(bitcode[32767 + Diff]);
			}
			
			var end0pos:int = 63;
			for (; (end0pos > 0) && (DU[end0pos] == 0); end0pos--) {
			}
			;
			
			if (end0pos == 0) {
				writeBits(EOB);
				return DC;
			}
			i = 1;
			while (i <= end0pos) {
				var startpos:int = i;
				for (; (DU[i] == 0) && (i <= end0pos); i++) {
				}
				var nrzeroes:int = i - startpos;
				if (nrzeroes >= 16) {
					for (var nrmarker:int = 1; nrmarker <= nrzeroes / 16; nrmarker++) {
						writeBits(M16zeroes);
					}
					nrzeroes = int(nrzeroes & 0xF);
				}
				writeBits(HTAC[nrzeroes * 16 + category[32767 + DU[i]]]);
				writeBits(bitcode[32767 + DU[i]]);
				i++;
			}
			if (end0pos != 63) {
				writeBits(EOB);
			}
			return DC;
		}
		
		/** @private */
		private var YDU:Array = new Array(64);
		
		/** @private */
		private var UDU:Array = new Array(64);
		
		/** @private */
		private var VDU:Array = new Array(64);
		
		
		/** @private */
		private function RGB2YUV(img:BitmapData, xpos:int, ypos:int):void {
			var pos:int = 0;
			for (var y:int = 0; y < 8; y++) {
				for (var x:int = 0; x < 8; x++) {
					var P:uint = img.getPixel32(xpos + x, ypos + y);
					var R:Number = Number((P >> 16) & 0xFF);
					var G:Number = Number((P >> 8) & 0xFF);
					var B:Number = Number((P) & 0xFF);
					YDU[pos] = (((0.29900) * R + (0.58700) * G + (0.11400) * B)) - 128;
					UDU[pos] = (((-0.16874) * R + (-0.33126) * G + (0.50000) * B));
					VDU[pos] = (((0.50000) * R + (-0.41869) * G + (-0.08131) * B));
					pos++;
				}
			}
		}
		
		/** @private */
		private var crcTable:Array;
		
		/** @private */
		private var crcTableComputed:Boolean = false;
		
		
		/** @private */
		private function writeChunk(png:ByteArray, type:uint, data:ByteArray):void {
			if (!crcTableComputed) {
				crcTableComputed = true;
				crcTable = [];
				var c:uint;
				for (var n:uint = 0; n < 256; n++) {
					c = n;
					for (var k:uint = 0; k < 8; k++) {
						if (c & 1) {
							c = uint(uint(0xedb88320) ^ uint(c >>> 1));
						} else {
							c = uint(c >>> 1);
						}
					}
					crcTable[n] = c;
				}
			}
			var len:uint = 0;
			if (data != null) {
				len = data.length;
			}
			png.writeUnsignedInt(len);
			var p:uint = png.position;
			png.writeUnsignedInt(type);
			if (data != null) {
				png.writeBytes(data);
			}
			var e:uint = png.position;
			png.position = p;
			c = 0xffffffff;
			for (var i:int = 0; i < (e - p); i++) {
				c = uint(crcTable[(c ^ png.readUnsignedByte()) & uint(0xff)] ^ uint(c >>> 8));
			}
			c = uint(c ^ uint(0xffffffff));
			png.position = e;
			png.writeUnsignedInt(c);
		}
		
		/** @private */
		private var file:FileReference;
		
		
		/** @private */
		public function encodePNG(img:BitmapData):ByteArray {
			var png:ByteArray = new ByteArray();
			png.writeUnsignedInt(0x89504e47);
			png.writeUnsignedInt(0x0D0A1A0A);
			var IHDR:ByteArray = new ByteArray();
			IHDR.writeInt(img.width);
			IHDR.writeInt(img.height);
			IHDR.writeUnsignedInt(0x08060000);
			IHDR.writeByte(0);
			writeChunk(png, 0x49484452, IHDR);
			var IDAT:ByteArray = new ByteArray();
			for (var i:int = 0; i < img.height; i++) {
				IDAT.writeByte(0);
				var p:uint;
				var j:int;
				if (!img.transparent) {
					for (j = 0; j < img.width; j++) {
						p = img.getPixel(j, i);
						IDAT.writeUnsignedInt(uint(((p & 0xFFFFFF) << 8) | 0xFF));
					}
				} else {
					for (j = 0; j < img.width; j++) {
						p = img.getPixel32(j, i);
						IDAT.writeUnsignedInt(uint(((p & 0xFFFFFF) << 8) | (p >>> 24)));
					}
				}
			}
			IDAT.compress();
			writeChunk(png, 0x49444154, IDAT);
			writeChunk(png, 0x49454E44, null);
			return png;
		}
		
		
		/** @private */
		public function encodeJPG(image:BitmapData):ByteArray {
			byteout = new ByteArray();
			bytenew = 0;
			bytepos = 7;
			
			writeWord(0xFFD8);
			writeAPP0();
			writeDQT();
			writeSOF0(image.width, image.height);
			writeDHT();
			writeSOS();
			
			var DCY:Number = 0;
			var DCU:Number = 0;
			var DCV:Number = 0;
			bytenew = 0;
			bytepos = 7;
			for (var ypos:int = 0; ypos < image.height; ypos += 8) {
				for (var xpos:int = 0; xpos < image.width; xpos += 8) {
					RGB2YUV(image, xpos, ypos);
					DCY = processDU(YDU, fdtbl_Y, DCY, YDC_HT, YAC_HT);
					DCU = processDU(UDU, fdtbl_UV, DCU, UVDC_HT, UVAC_HT);
					DCV = processDU(VDU, fdtbl_UV, DCV, UVDC_HT, UVAC_HT);
				}
			}
			
			if (bytepos >= 0) {
				var fillbits:BitString = new BitString();
				fillbits.len = bytepos + 1;
				fillbits.val = (1 << (bytepos + 1)) - 1;
				writeBits(fillbits);
			}
			
			writeWord(0xFFD9);
			return byteout;
		}
		
		
		/**
		 * Inicializa uma nova classe de exportação de arquivos
		 * @param	quality Qualidade do arquivo JPG
		 */
		public function FileExport(quality:Number = 80) {
			if (quality <= 0) {
				quality = 1;
			}
			if (quality > 100) {
				quality = 100;
			}
			var sf:int = 0;
			if (quality < 50) {
				sf = int(5000 / quality);
			} else {
				sf = int(200 - quality * 2);
			}
			initHuffmanTbl();
			initCategoryNumber();
			initQuantTables(sf);
			file = new FileReference();
		}
		
		
		/**
		 * Salva arquivo de um bitmap
		 * @param	bmp		Bitmapdata a ser salvo
		 * @param	name	Nome do arquivo
		 * @return
		 */
		public function bitmap(bmp:BitmapData, name:String):ByteArray {
			var ftype:Array = name.split(".");
			var ext:String = String(ftype[ftype.length - 1]).toLowerCase();
			switch (ext) {
				case "jpg": 
					return encodeJPG(bmp);
					break;
				case "png": 
					return encodePNG(bmp);
					break
				default: 
					return null;
			}
		
		}
		
		
		/**
		 * Salva arquivo de um DisplayObject
		 * @param	target	DisplayObject a ser salvo
		 * @param	name	Nome do arquivo
		 * @return
		 */
		public function movie(target:DisplayObject, name:String, mt:Matrix = null, transparency:Boolean = false):ByteArray {
			var bds:Object = target.getBounds(target);
			mt = mt || new Matrix(1, 0, 0, 1, -bds.x, -bds.y);
			var bmp:BitmapData = new BitmapData(bds.width * mt.a, bds.height * mt.d, transparency, 0);
			bmp.draw(target, mt);
			return bitmap(bmp, name);
		}
		
		
		/**
		 * Salva um arquivo
		 * @param	value	Valor a ser inserido no arquivo
		 * @param	name	Nome do arquivo
		 * @return
		 */
		public function dataFile(value:*, name:String):Boolean {
			if (name.indexOf(".") > -1) {
				if (file.save(value, name)) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}
	
	}
}


/** @private */
class BitString {
	/** @private */
	public var len:int = 0;
	
	/** @private */
	public var val:int = 0;
	
	public function BitString() {
		
	}
}
