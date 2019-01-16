//
//  ATMimeType.swift
//  ATKit
//
//  Created by rupendra on 12/13/16.
//  Copyright © 2016 Example. All rights reserved.
//

import UIKit

public enum ATMimeType: String {
    case imageBmp = "image/bmp"
    case imageGif = "image/gif"
    case imageJpeg = "image/jpeg"
    case imageIcon = "image/x-icon"
    case imagePict = "image/pict"
    case imagePng = "image/png"
    case imageDwg = "image/x-dwg"
    case imageTiff = "image/tiff"
    case imageWbmp = "image/vnd.wap.wbmp"
    
    case applicationZip = "application/zip"
    case applicationOctetStream = "application/octet-stream"
    case applicationBook = "application/book"
    case applicationBzip = "application/x-bzip"
    case applicationBzip2 = "application/x-bzip2"
    case applicationCompressed = "application/x-compressed"
    case applicationGzip = "application/x-gzip"
    case applicationHelpFile = "application/x-helpfile"
    case applicationJavascript = "application/javascript"
    case applicationPkcs12 = "application/pkcs-12"
    case applicationPkg = "application/x-newton-compatible-pkg"
    case applicationMSPowerpoint = "application/mspowerpoint"
    case applicationExcel = "application/excel"
    case applicationMSWord = "application/msword"
    case applicationDocx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    case applicationJavaByteCode = "application/java-byte-code"
    case applicationPdf = "application/pdf"
    
    case textPlain = "text/plain"
    case textHtml = "text/html"
    case textAsp = "text/asp"
    case textCss = "text/css"
    
    case videoAvi = "video/avi"
    case videoAvs = "video/avs-video"
    case videoMpeg = "video/mpeg"
    case videoMotionJpeg = "video/x-motion-jpeg"
    case videoQuicktime = "video/quicktime"
    case videoSgiMovie = "video/x-sgi-movie"
    
    case audioMidi = "audio/midi"
    case audioMpeg = "audio/mpeg"
    case musicKaraoke = "music/x-karaoke"
    case audiMpequrl = "audio/x-mpequrl"
    case audioMpeg3 = "audio/mpeg3"
    case audioWav = "audio/wav"
    
    
    static let allValues = [imageBmp, imageGif, imageJpeg, imageIcon, imagePict, .imagePng, .imageDwg, .imageTiff, .imageWbmp, .applicationZip, .applicationOctetStream, .applicationBook, .applicationBzip, .applicationBzip2, .applicationCompressed, .applicationGzip, .applicationHelpFile, .applicationJavascript, .applicationPkcs12, .applicationPkg, .applicationMSPowerpoint, .applicationExcel, .applicationMSWord, .applicationDocx, .applicationJavaByteCode, .applicationPdf, .textPlain, .textHtml, .textAsp, .textCss, .videoAvi, .videoAvs, .videoMpeg, .videoMotionJpeg, .videoQuicktime, .videoSgiMovie, .audioMidi, .audioMpeg, .musicKaraoke, .audiMpequrl, .audioMpeg3, .audioWav]
    
    
    public init(rawValue pRawValue :String) {
        var aValue :ATMimeType = ATMimeType.applicationOctetStream
        for aCase in ATMimeType.allValues {
            if aCase.rawValue == pRawValue {
                aValue = aCase
                break
            }
        }
        self = aValue
    }
    
    
    public init(fileExtension pFileExtension :String) {
        var aValue :ATMimeType = ATMimeType.applicationOctetStream
        
        if pFileExtension == "bmp" {
            aValue = .imageBmp
        } else if pFileExtension == "gif" {
            aValue = .imageGif
        } else if pFileExtension == "jpg" {
            aValue = .imageJpeg
        } else if pFileExtension == "ico" {
            aValue = .imageIcon
        } else if pFileExtension == "pic" {
            aValue = .imagePict
        } else if pFileExtension == "png" {
            aValue = .imagePng
        } else if pFileExtension == "svf" {
            aValue = .imageDwg
        } else if pFileExtension == "tiff"
        || pFileExtension == "tif" {
            aValue = .imageTiff
        } else if pFileExtension == "wbmp" {
            aValue = .imageWbmp
        } else if pFileExtension == "zip" {
            aValue = .applicationZip
        } else if pFileExtension == "bin"
        || pFileExtension == "exe" {
            aValue = .applicationOctetStream
        } else if pFileExtension == "book" {
            aValue = .applicationBook
        } else if pFileExtension == "bz" {
            aValue = .applicationBzip
        } else if pFileExtension == "bz2" {
            aValue = .applicationBzip2
        } else if pFileExtension == "gz" {
            aValue = .applicationCompressed
        } else if pFileExtension == "gzip" {
            aValue = .applicationGzip
        } else if pFileExtension == "hlp" {
            aValue = .applicationHelpFile
        } else if pFileExtension == "js" {
            aValue = .applicationJavascript
        } else if pFileExtension == "p12" {
            aValue = .applicationPkcs12
        } else if pFileExtension == "pkg" {
            aValue = .applicationPkg
        } else if pFileExtension == "ppt"
        || pFileExtension == "ppz" {
            aValue = .applicationMSPowerpoint
        } else if pFileExtension == "xls" {
            aValue = .applicationExcel
        } else if pFileExtension == "doc" {
            aValue = .applicationMSWord
        } else if pFileExtension == "docx" {
            aValue = .applicationDocx
        } else if pFileExtension == "class" {
            aValue = .applicationJavaByteCode
        } else if pFileExtension == "pdf" {
            aValue = .applicationPdf
        } else if pFileExtension == "txt"
        || pFileExtension == "text"
        || pFileExtension == "log" {
            aValue = .textPlain
        } else if pFileExtension == "html"
        || pFileExtension == "htm"
        || pFileExtension == "shtml" {
            aValue = .textHtml
        } else if pFileExtension == "asp" {
            aValue = .textAsp
        } else if pFileExtension == "css" {
            aValue = .textCss
        } else if pFileExtension == "avi" {
            aValue = .videoAvi
        } else if pFileExtension == "avs" {
            aValue = .videoAvs
        } else if pFileExtension == "m2v"
        || pFileExtension == "mpe" {
            aValue = .videoMpeg
        } else if pFileExtension == "mjpg" {
            aValue = .videoMotionJpeg
        } else if pFileExtension == "moov"
        || pFileExtension == "mov" {
            aValue = .videoQuicktime
        } else if pFileExtension == "movie" {
            aValue = .videoSgiMovie
        } else if pFileExtension == "midi"
        || pFileExtension == "mid" {
            aValue = .audioMidi
        } else if pFileExtension == "m2a"
        || pFileExtension == "mp2"
        || pFileExtension == "mpa" {
            aValue = .audioMpeg
        } else if pFileExtension == "kar" {
            aValue = .musicKaraoke
        } else if pFileExtension == "m3u" {
            aValue = .audiMpequrl
        } else if pFileExtension == "mp3" {
            aValue = .audioMpeg3
        } else if pFileExtension == "wav" {
            aValue = .audioWav
        }
        
        self = aValue
    }
}
