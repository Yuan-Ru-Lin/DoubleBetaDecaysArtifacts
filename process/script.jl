using DelimitedFiles, InlineStrings, Downloads, ProgressMeter

isotopes = vec(readdlm("isotopes.txt", String7))

mkpath("data/raw")
@showprogress for isotope in isotopes, i in [0, 2]
    Downloads.download(
        "https://nucleartheory.yale.edu/sites/default/files/files/$(isotope)_$(i)vbb.zip",
        "data/raw/$(isotope)_$(i)vbb.zip",
    )
end

mkpath("data/decompressed")
for isotope in isotopes, i in [0, 2]
    run(`unzip -o data/raw/$(isotope)_$(i)vbb.zip -d data/decompressed/`)
end

# 76Ge -> Ge76 etc. This way, one just can write :Ge76, etc, in the code,
# instead of having to write Symbol("76Ge")
modified_names = String7.(replace.(isotopes, r"(\d+)([A-Za-z]+)" => s"\2\1"))
mkpath("data/KotilaIachello2012")
for (isotope, modified_name) in zip(isotopes, modified_names)
    dest = mkpath("data/KotilaIachello2012/$(modified_name)")
    mv("data/decompressed/$(isotope)_ses_0v.txt", joinpath(dest, "ses_0v.txt"))
    mv("data/decompressed/$(isotope)_cor_0v.txt", joinpath(dest, "cor_0v.txt"))
    mv("data/decompressed/$(isotope)_ses.txt", joinpath(dest, "ses.txt"))
    mv("data/decompressed/$(isotope)_cor.txt", joinpath(dest, "cor.txt"))
    mv("data/decompressed/$(isotope)_2ds.txt", joinpath(dest, "2ds.txt"))
    mv("data/decompressed/$(isotope)_sums.txt", joinpath(dest, "sums.txt"))
end
