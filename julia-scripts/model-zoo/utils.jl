struct ConfusionMatrix
    matrix
    classlabels

    function ConfusionMatrix(tn, fp, fn, tp; classlabels=nothing)
        ConfusionMatrix([tn fp ;fn tp],classlabels=classlabels)
    end

    function ConfusionMatrix(matrix::Matrix; classlabels=nothing)
        if classlabels == nothing
            _, n = size(matrix)
            classlabels = ["class $x" for x in 1:n]
        end
        new(matrix, classlabels)
    end

end