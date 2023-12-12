#------------------------------------------------------------------------------
#
# Project: DESIDE Document Deliverables
# Authors: Lubomir Dolezal <lubomir.dolezal@eox.at>
#          Nikola Jankovic <nikola.jankovic@eox.at>
#
#------------------------------------------------------------------------------
# Copyright (C) 2023 EOX IT Services GmbH <https://eox.at>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies of this Software or works derived from this Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#-----------------------------------------------------------------------------

FROM asciidoctor/docker-asciidoctor:1.27

LABEL name="DESIDE Document Deliverables" \
    vendor="EOX IT Services GmbH <https://eox.at>" \
    license="MIT Copyright (C) 2023 EOX IT Services GmbH <https://eox.at>" \
    type="DESIDE Document Deliverables"

WORKDIR "/opt/documents"

# version of pandoc set to 2.10 because newer breaks some features for pandiff
# version of pandiff set to this specific commit, because it is last pre-typescript version
ENV TGZ="pandoc.tar.gz" \
    PANDOC_VERSION="2.10" \
    PANDIFF_GIT_TAG="v0.5.1"
ENV PANDOC_DOWNLOAD_URL https://github.com/jgm/pandoc/releases/download/"$PANDOC_VERSION"/pandoc-"$PANDOC_VERSION"-linux-amd64.tar.gz

RUN curl -fsSL "$PANDOC_DOWNLOAD_URL" -o "$TGZ" \
    && tar xzf $TGZ --strip-components 1 -C /usr/local/ \
    && apk add --update zip nodejs bash npm \
    && rm -rf /var/cache/apk/* \
    && npm install -g "git://github.com/lubojr/pandiff.git#$PANDIFF_GIT_TAG" \
    && npm cache clean --force \
    && gem install asciidoctor-lists \
    && rm "$TGZ"

CMD /bin/bash
