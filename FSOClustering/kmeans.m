function z = kmeans(x)
    global im;
    z = sum(min(dist(im, x)));
end