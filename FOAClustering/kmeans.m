function z = kmeans(x)
    global im;
    z = sum(min(transpose(dist(im, x))));
end