using DelimitedFiles, InlineStrings, Downloads, ProgressMeter, Glob

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

# I stop here; it's time to figure out what DBDG.jl expects
mkpath("data/KotilaIachello2012")
for isotope in isotopes
    dest = mkpath("data/KotilaIachello2012/$(isotope)")
    mv("data/decompressed/$(isotope)_ses_0v.txt", joinpath(dest, "ses_0v.txt"))
    mv("data/decompressed/$(isotope)_cor_0v.txt", joinpath(dest, "cor_0v.txt"))
    mv("data/decompressed/$(isotope)_ses.txt", joinpath(dest, "ses.txt"))
    mv("data/decompressed/$(isotope)_cor.txt", joinpath(dest, "cor.txt"))
    mv("data/decompressed/$(isotope)_2ds.txt", joinpath(dest, "2ds.txt"))
    mv("data/decompressed/$(isotope)_sums.txt", joinpath(dest, "sums.txt"))
end
