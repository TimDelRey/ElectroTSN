package httpclient

import (
	"fmt"
	"io"
	"net/http"
	"net/url"
	"time"

	"go_services/pkg/logger"
)

type Client struct {
	baseURL string
	http    *http.Client
}

func New(baseURL string, timeout time.Duration) *Client {
	return &Client{
		baseURL: baseURL,
		http: &http.Client{
			Timeout: timeout,
		},
	}
}

func (c *Client) doGetRequest(path string, params map[string]string) ([]byte, error) {
	u, err := url.Parse(c.baseURL + path)
	if err != nil {
		return nil, err
	}

	q := u.Query()
	for k, v := range params {
		q.Set(k, v)
	}
	u.RawQuery = q.Encode()

	resp, err := c.http.Get(u.String())
	if err != nil {
		logger.L.Errorf("http request failed: %v", err)
		return nil, err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		logger.L.Errorf("failed to read response: %v", err)
		return nil, err
	}
	return body, nil
}


func (c *Client) GetInd(userID int, date string) ([]byte, error) {
	return c.doGetRequest(
        "/api/v1/indications/show_person",
        map[string]string{
            "user_id": fmt.Sprintf("%d", userID),
            "date": date,
        },
    )
}

func (c *Client) GetInds(date string) ([]byte, error) {
    return c.doGetRequest(
        "/api/v1/indications/show_month_collective",
        map[string]string{
            "date": date,
        },
    )
}

func (c *Client) CompleteReceipt(receiptID int) ([]byte, error) {
	path := fmt.Sprintf("/api/v1/receipts/%d/complete", receiptID)
	return c.doGetRequest(path, nil)
}

func (c *Client) Tariffs() ([]byte, error) {
	return c.doGetRequest("/api/v1/tariffs/actual", nil)
}

func (c *Client) GetUser(userID int) ([]byte, error) {
	path := fmt.Sprintf("/api/v1/users/%d", userID)
	return c.doGetRequest(path, nil)
}
