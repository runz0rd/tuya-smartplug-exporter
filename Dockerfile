# Copyright 2022 Richard Kosegi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.20 as builder

WORKDIR /build
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download
COPY pkg/ pkg/
COPY main.go main.go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o exporter main.go

FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /build/exporter .

USER 65532:65532

ENTRYPOINT ["/exporter"]

