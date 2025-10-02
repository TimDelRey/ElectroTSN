package s3

import (
	"context"
	"fmt"
	"io"
	// "os"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

type Client struct {
	s3     *s3.Client
	Bucket string
}

func NewClient() (*Client, error) {
	const endpoint = "https://storage.yandexcloud.net"
	accessKey := ""
	secretKey := ""
	bucket := "receipts-tsn-stoletovskiy"
	region := "ru-central1"

	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion(region),
		config.WithCredentialsProvider(credentials.NewStaticCredentialsProvider(accessKey, secretKey, "")),
	)
	if err != nil {
		return nil, fmt.Errorf("failed to load AWS config: %w", err)
	}

	client := s3.NewFromConfig(cfg, func(o *s3.Options) {
		o.EndpointResolver = s3.EndpointResolverFromURL(endpoint)
	})

	return &Client{
		s3:     client,
		Bucket: bucket,
	}, nil
}

func (c *Client) UploadFile(key string, body io.Reader, contentType string) error {
	_, err := c.s3.PutObject(context.TODO(), &s3.PutObjectInput{
		Bucket:      aws.String(c.Bucket),
		Key:         aws.String(key),
		Body:        body,
		ContentType: aws.String(contentType),
	})
	if err != nil {
		return fmt.Errorf("failed to upload file: %w", err)
	}
	return nil
}
