class JenkinsHasher {
    int _hash = 0;

    JenkinsHasher add(int value) {
        _hash += value;
        _hash += _hash << 10;
        _hash ^= _hash >> 6;
        return this;
    }

    int get hash {
        int hash = _hash;
        hash += (hash << 3);
        hash ^= (hash >> 11);
        hash += (hash << 15);
        return hash;
    }
}