using Images
using ImageIO
using ImageMagick
using LinearAlgebra
using Pipe: @pipe
using ProgressMeter
using CSV
using DataFrames
X = load("jpgtest.jpg")

a = @pipe X |> Float64.(Gray.(_)) |> svd(_).S[1:10]'

data = Float64.(Gray.(X))
abssvd = svd(data)abs
a = Array{Float64}(undef, 0, 10)
@time a = vcat(a,re)

"""
Usage: 
```julia
    recodeimage(path_to_folder_with_images, no_of_required_singular_vals)
```
Currently only supported for jpeg/png files 
"""
function recodeimage(pathtoimage, n_singularvlas)
    imagelist = glob("*.jpg", pathtoimage)
    append!(imagelist,  glob("*.png", pathtoimage))
    recodedArray = Array{Float64}(undef, 0, n_singularvlas)
    @showprogress for images in imagelist
        X = load(images)
        img_singluar = @pipe X |> Float64.(Gray.(_)) |> svd(_).S[1:n_singularvlas]'
        recodedArray = vcat(recodedArray, img_singluar) 
    end
    filename = joinpath(pathtoimage, "image_recoded.csv")
    CSV.write(filename,  DataFrame(recodedArray), writeheader=true)
end
using StatsBase
recodeimage(pwd(),2)
using WAV
using Pipe: @pipe
using MFCC
using Glob
using WAV

temp = Array{Float64}(undef,0,10)
x,fs = wavread("ENG_M.wav")
a = collect(mfcc(x,fs, numcep = 10)[1])
temp = vcat(temp,mean(a,dims=1))
using CSV
using DataFrames
using ProgressMeter
function recodeaudio(filepath,ncep)
    audiolist = glob("*.wav",filepath)
    recodedArray = Array{Float64}(undef, 0, ncep)
    @showprogress for files in audiolist
        x,fs = wavread(files)
        cep = collect(mfcc(x,fs, numcep = ncep)[1])# this is a matrix with ncep columns 
        recodedArray = vcat(recodedArray, mean(cep,dims=1))
    end
    filename = joinpath(filepath, "audio_recoded.csv")
    CSV.write(filename,  DataFrame(recodedArray), writeheader=true)
end

using TextAnalysis
using Taro
using Languages
Taro.init()
function recodetext(pathtotxt, n_singularvals)
    files = glob("*.pdf", pathtotxt)
    docs = Array{StringDocument{String},1}[]
    getTitle(t) = TextAnalysis.sentence_tokenize(Languages.English(), t)[1]
   @showprogress for i in 1:length(files)
        meta,txt = Taro.extract(files[i]);
        txt = replace(txt, '\n' => ' ')
        title = getTitle(txt)
        dm = TextAnalysis.DocumentMetadata(Languages.English(), title, "", meta["Creation-Date"] )
        doc = StringDocument(txt, dm)
        docs = vcat(docs, doc)
    end
    crps = Corpus(docs)
    
    prepare!(crps, strip_non_letters | strip_punctuation | strip_case | strip_stopwords)
    stem!(crps)
    update_lexicon!(crps)
    update_inverse_index!(crps)
    U,S,Vt = @pipe crps |> DocumentTermMatrix(_) |> dtm(_, :dense) |> svd(_)
    if n_singularvals > length(S)
        println("You have set more number of singluar values than present \n so seting number of singluar values = length(singular values)")
        n_singularvals = length(S)
    end
    DTM = U[:,1:n_singularvals]*diagm(S[1:n_singularvals])*Vt[:,1:n_singularvals]'
    filename = joinpath(pathtotxt, "reconstructed_document_term_matrix.csv")
    CSV.write(filename,  DataFrame(DTM), writeheader=true)
end 
 
a = glob("*.pdf", pwd())
docs= Any[]
getTitle(t) = TextAnalysis.sentence_tokenize(Languages.English(), t)[1]
for i in 1:length(a)
        meta,txt = Taro.extract(a)
        txt = replace(txt, '\n' => ' ')
        title = getTitle(txt)
        dm = TextAnalysis.DocumentMetadata(Languages.English(), title, "", meta["Creation-Date"] )
        doc = StringDocument(txt, dm)
        push!(docs, doc)

    end
end
a = recodetext(pwd(),50)
