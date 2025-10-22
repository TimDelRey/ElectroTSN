package s3

import (
	"context"
	"fmt"
	"io"
	"os"

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
	endpoint := os.Getenv("YANDEX_CLOUD_ENDPOINT")
	accessKey := os.Getenv("YANDEX_ACCESS_KEY_ID")
	secretKey := os.Getenv("YANDEX_SECRET_ACCESS_KEY")
	bucket := os.Getenv("YANDEX_CLOUD_BUCKET")
	region := os.Getenv("REGION")

	cfg, err := config.LoadDefaultConfig(
		context.TODO(),
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

func (c *Client) DownloadFile(key string, contentType string) (*s3.GetObjectOutput, error) {
    file, err := c.s3.GetObject(context.TODO(), &s3.GetObjectInput{
		Bucket:              aws.String(c.Bucket),
		Key:                 aws.String(key),
		ResponseContentType: aws.String(contentType),
	})
	if err != nil {
		return nil, fmt.Errorf("failed to download file: %w", err)
	}
	return file, nil
}
